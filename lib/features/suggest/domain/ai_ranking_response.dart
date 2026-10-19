import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_ranking_response.freezed.dart';
part 'ai_ranking_response.g.dart';

/// Single recipe recommendation ranked and adapted by AI
@freezed
abstract class AiRankedItem with _$AiRankedItem {
  const factory AiRankedItem({
    required String recipeId,
    required String reasonAr,
    String? substitutionTip,
  }) = _AiRankedItem;

  factory AiRankedItem.fromJson(Map<String, dynamic> json) =>
      _$AiRankedItemFromJson(json);
}

/// Collection of AI-ranked recipe suggestions
@freezed
abstract class AiRankingResponse with _$AiRankingResponse {
  const factory AiRankingResponse({
    @Default(<AiRankedItem>[]) List<AiRankedItem> items,
  }) = _AiRankingResponse;

  factory AiRankingResponse.fromJson(Map<String, dynamic> json) =>
      _$AiRankingResponseFromJson(json);
}
