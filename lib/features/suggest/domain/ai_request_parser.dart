import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/ai/ai_prompts.dart';
import 'package:lunchbox_buddy/core/data/database/daos.dart';
import 'package:lunchbox_buddy/core/data/models/ingredient.dart';
import 'package:lunchbox_buddy/core/data/providers.dart';
import 'package:lunchbox_buddy/core/errors/failures.dart';
import 'package:lunchbox_buddy/features/suggest/domain/ai_parsed_request.dart';

/// Service that turns free text or spoken Arabic/English requests into structured [AiParsedRequest].
class AiRequestParser {
  AiRequestParser({
    required this.aiClient,
    required this.ingredientsDao,
  });

  final AiClient aiClient;
  final IngredientsDao ingredientsDao;

  /// Parses natural language input into structured request fields.
  /// - Enforces 8s timeout
  /// - Automatic 1 retry on parse failure via [AiClient]
  /// - Heavy parsing executed in an isolate
  Future<Result<AiParsedRequest>> parseRequest({
    required String rawText,
    List<Ingredient>? customIngredients,
  }) async {
    if (rawText.trim().isEmpty) {
      return const ErrorResult(
        AiSchemaFailure('Input text cannot be empty'),
      );
    }

    try {
      final ingredients = customIngredients ?? await ingredientsDao.getAllIngredients();

      final prompt = AiPrompts.buildParseRequestPrompt(
        rawUserInput: rawText,
        canonicalIngredients: ingredients,
      );

      final result = await aiClient.generateStructured<AiParsedRequest>(
        prompt: prompt,
        responseSchema: AiPrompts.parseRequestSchema,
        systemInstruction: AiPrompts.parseRequestSystemInstruction,
        timeoutSeconds: 8,
        retryOnFormatError: true,
        parser: (json) => AiParsedRequest.fromJson(json),
      );

      return result;
    } catch (e) {
      return ErrorResult(
        UnknownFailure('Request parsing failed: $e', e),
      );
    }
  }
}

/// Riverpod provider for AiRequestParser
final aiRequestParserProvider = Provider<AiRequestParser>((ref) {
  return AiRequestParser(
    aiClient: ref.watch(aiClientProvider),
    ingredientsDao: ref.watch(ingredientsDaoProvider),
  );
});
