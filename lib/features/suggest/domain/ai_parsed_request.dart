import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_parsed_request.freezed.dart';
part 'ai_parsed_request.g.dart';

/// Structured response model representing an AI-parsed free-text or voice meal request.
@freezed
abstract class AiParsedRequest with _$AiParsedRequest {
  const factory AiParsedRequest({
    @Default('lunchbox') String mealType,
    int? maxMinutes,
    @Default(<String>[]) List<String> moodTags,
    @Default(<String>[]) List<String> availableIngredientIds,
    @Default(<String>[]) List<String> excludedIngredientIds,
    @Default(<String>[]) List<String> unresolvedIngredients,
    String? confidenceReason,
  }) = _AiParsedRequest;

  factory AiParsedRequest.fromJson(Map<String, dynamic> json) =>
      _$AiParsedRequestFromJson(json);
}
