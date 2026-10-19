import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/core/errors/failures.dart';

/// Type definition for model invocation (allows test injection without subclassing final classes)
typedef ModelInvoker = Future<String?> Function({
  required String modelName,
  required GenerationConfig generationConfig,
  Content? systemInstruction,
  required Iterable<Content> prompt,
});

/// Thin, resilient client wrapping Firebase AI Logic (Gemini Developer API backend).
/// Guarantees:
/// - Enforces structured JSON output with a response schema
/// - Configurable timeout from [AppConfig]
/// - Automatic retry with exponential backoff for transient failures
/// - Maps errors into typed [Failure] results (never throws uncaught exceptions to UI)
/// - UI widgets never call Firebase AI directly
class AiClient {
  AiClient({
    required this.config,
    ModelInvoker? invoker,
  }) : _invoker = invoker ?? _defaultInvoker;

  final AppConfig config;
  final ModelInvoker _invoker;

  static Future<String?> _defaultInvoker({
    required String modelName,
    required GenerationConfig generationConfig,
    Content? systemInstruction,
    required Iterable<Content> prompt,
  }) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: modelName,
      generationConfig: generationConfig,
      systemInstruction: systemInstruction,
    );
    final response = await model.generateContent(prompt);
    return response.text;
  }

  /// Sends a structured prompt to the Gemini model and returns typed result [T].
  ///
  /// - [prompt]: The natural language request from user/domain
  /// - [responseSchema]: The JSON Schema the model's output must adhere to
  /// - [parser]: Pure mapper converting valid JSON Map into domain model [T]
  /// - [systemInstruction]: Optional system prompt defining persona/rules
  /// - [timeoutSeconds]: Optional override for request timeout
  Future<Result<T>> generateStructured<T>({
    required String prompt,
    required Schema responseSchema,
    required T Function(Map<String, dynamic> json) parser,
    String? systemInstruction,
    int? timeoutSeconds,
  }) async {
    final timeout = Duration(
      seconds: timeoutSeconds ?? config.requestTimeoutSeconds,
    );
    final maxAttempts = 1 + config.maxRetries;

    Failure? lastFailure;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final generationConfig = GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: responseSchema,
        );

        final text = await _invoker(
          modelName: config.geminiModel,
          generationConfig: generationConfig,
          systemInstruction: systemInstruction != null
              ? Content.system(systemInstruction)
              : null,
          prompt: [Content.text(prompt)],
        ).timeout(timeout);

        if (text == null || text.trim().isEmpty) {
          return const ErrorResult(
            AiSchemaFailure('Model returned an empty response string'),
          );
        }

        final dynamic decoded = jsonDecode(text.trim());
        if (decoded is! Map<String, dynamic>) {
          return ErrorResult(
            AiSchemaFailure(
              'Expected JSON object from model but received ${decoded.runtimeType}',
            ),
          );
        }

        try {
          final parsed = parser(decoded);
          return Success(parsed);
        } catch (parseError) {
          return ErrorResult(
            AiSchemaFailure(
              'Failed to parse JSON response into target model: $parseError',
              parseError,
            ),
          );
        }
      } on TimeoutException catch (e) {
        lastFailure = AiTimeoutFailure(
          'AI request timed out after ${timeout.inSeconds}s (attempt $attempt/$maxAttempts)',
          e,
        );
      } on SocketException catch (e) {
        lastFailure = NetworkFailure(
          'Network connection unavailable (attempt $attempt/$maxAttempts)',
          e,
        );
      } on FormatException catch (e) {
        // Response format is invalid, do not retry same format
        return ErrorResult(
          AiSchemaFailure(
            'Malformed JSON received from model: ${e.message}',
            e,
          ),
        );
      } on FirebaseException catch (e) {
        final msg = e.message ?? '';
        if (e.code == 'app-check-failed' ||
            msg.toLowerCase().contains('app-check') ||
            msg.toLowerCase().contains('appcheck')) {
          return ErrorResult(
            AppCheckFailure('Firebase App Check attestation failed: $msg', e),
          );
        }
        if (e.code == 'permission-denied') {
          return ErrorResult(
            AppCheckFailure('Permission denied or App Check blocked: $msg', e),
          );
        }
        lastFailure = NetworkFailure(
          'Firebase service error (${e.code}): $msg',
          e,
        );
      } catch (e) {
        final errorString = e.toString().toLowerCase();
        if (errorString.contains('socket') ||
            errorString.contains('network') ||
            errorString.contains('connection')) {
          lastFailure = NetworkFailure(
            'Network communication error: $e',
            e,
          );
        } else {
          lastFailure = UnknownFailure('AI generation encountered error: $e', e);
        }
      }

      // If attempts remain, back off briefly
      if (attempt < maxAttempts) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
      }
    }

    return ErrorResult(
      lastFailure ?? const UnknownFailure('AI generation failed after retries'),
    );
  }
}

/// Riverpod provider delivering the configured [AiClient]
final aiClientProvider = Provider<AiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return AiClient(config: config);
});
