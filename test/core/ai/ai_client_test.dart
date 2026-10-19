import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/core/errors/failures.dart';

void main() {
  group('AiClient Unit Tests', () {
    const testConfig = AppConfig(
      geminiModel: 'gemini-2.5-flash',
      requestTimeoutSeconds: 2,
      maxRetries: 1,
    );

    final testSchema = Schema.object(
      properties: {
        'idea': Schema.string(),
      },
    );

    test('successful structured response parses valid JSON map', () async {
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          expect(modelName, 'gemini-2.5-flash');
          return '{"idea": "Apple Slices"}';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 'Apple Slices');
    });

    test('empty response returns AiSchemaFailure', () async {
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return '   ';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<AiSchemaFailure>());
    });

    test('malformed JSON returns AiSchemaFailure without retrying', () async {
      var callCount = 0;
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          return '{not_valid_json}';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<AiSchemaFailure>());
      // Malformed format errors are deterministic; do not retry
      expect(callCount, 1);
    });

    test('parser exception returns AiSchemaFailure', () async {
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          return '{"wrong_key": 123}';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<AiSchemaFailure>());
    });

    test('timeout triggers retry and returns AiTimeoutFailure', () async {
      var callCount = 0;
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          await Future<void>.delayed(const Duration(milliseconds: 300));
          return '{"idea": "Late snack"}';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
        timeoutSeconds: 0,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<AiTimeoutFailure>());
      // 1 attempt + 1 retry = 2 attempts
      expect(callCount, 2);
    });

    test('SocketException triggers retry and returns NetworkFailure', () async {
      var callCount = 0;
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          throw const SocketException('Network is down');
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<NetworkFailure>());
      expect(callCount, 2);
    });

    test('transient socket failure followed by success recovers on retry', () async {
      var callCount = 0;
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          if (callCount == 1) {
            throw const SocketException('Temporary glitch');
          }
          return '{"idea": "Carrot Sticks"}';
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, 'Carrot Sticks');
      expect(callCount, 2);
    });

    test('App Check permission denial returns AppCheckFailure without retry', () async {
      var callCount = 0;
      final client = AiClient(
        config: testConfig,
        invoker: ({
          required String modelName,
          required GenerationConfig generationConfig,
          Content? systemInstruction,
          required Iterable<Content> prompt,
        }) async {
          callCount++;
          throw FirebaseException(
            plugin: 'firebase_ai',
            code: 'app-check-failed',
            message: 'App Check token is invalid or missing',
          );
        },
      );

      final result = await client.generateStructured<String>(
        prompt: 'Give me a snack',
        responseSchema: testSchema,
        parser: (json) => json['idea'] as String,
      );

      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, isA<AppCheckFailure>());
      // Security/App Check failure shouldn't retry uselessly
      expect(callCount, 1);
    });
  });
}
