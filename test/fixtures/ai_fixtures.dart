/// Recorded JSON fixtures for AI unit and integration tests.
/// Includes valid outputs, malformed JSON, unknown IDs, and empty lists.
class AiFixtures {
  AiFixtures._();

  /// Valid response for parseRequest ("ولدي ما يحب الخضار وعندي دجاج وأرز وما عندي وقت")
  static const String validParseArabicRequestJson = '''
{
  "mealType": "lunchbox",
  "maxMinutes": 20,
  "moodTags": ["quick"],
  "availableIngredientIds": ["chicken_breast", "white_rice"],
  "excludedIngredientIds": ["spinach", "broccoli", "carrot"],
  "unresolvedIngredients": []
}
''';

  /// Valid response for parseRequest with unresolved items ("أبغى شي خفيف للمدرسة مع خبز تنور وبدون جبن")
  static const String validParseWithUnresolvedJson = '''
{
  "mealType": "lunchbox",
  "maxMinutes": 15,
  "moodTags": ["quick"],
  "availableIngredientIds": [],
  "excludedIngredientIds": ["cheddar_cheese"],
  "unresolvedIngredients": ["خبز تنور"]
}
''';

  /// Empty lists parse request
  static const String emptyParseRequestJson = '''
{
  "mealType": "lunchbox",
  "maxMinutes": 20,
  "moodTags": [],
  "availableIngredientIds": [],
  "excludedIngredientIds": [],
  "unresolvedIngredients": []
}
''';

  /// Malformed parse request (corrupted JSON missing braces)
  static const String malformedParseRequestJson = '''
{"mealType": "lunchbox", "maxMinutes": 20, "moodTags": ["quick",
''';

  /// Valid ranking response with 3 items matching known candidate IDs
  static const String validRankingJson = '''
{
  "items": [
    {
      "recipeId": "rec_chicken_rice_bowl",
      "reasonAr": "وجبة غنية بالبروتين ومحبوبة وسهلة التحضير في وقت قياسي.",
      "substitutionTip": "يمكنك إضافة مكعبات خيار مقرمشة على الجنب."
    },
    {
      "recipeId": "rec_egg_toast_triangles",
      "reasonAr": "فطور وسناك سريع يمنح طفلك طاقة مدرسية متكاملة.",
      "substitutionTip": null
    },
    {
      "recipeId": "rec_banana_oat_pancakes",
      "reasonAr": "بان كيك لذيذ يخلو من السكر المكرر ويعجب الأطفال الانتقائيين.",
      "substitutionTip": "استبدلي حليب البقر بحليب الشوفان إذا لزم الأمر."
    }
  ]
}
''';

  /// Ranking response returning completely unknown recipe IDs (must be rejected)
  static const String unknownIdsRankingJson = '''
{
  "items": [
    {
      "recipeId": "mystery_recipe_9999",
      "reasonAr": "وصفة غير مسجلة في قاعدة البيانات.",
      "substitutionTip": null
    },
    {
      "recipeId": "fake_nuggets_ultra",
      "reasonAr": "وجبة سريعة من مكان مجهول.",
      "substitutionTip": null
    }
  ]
}
''';

  /// Ranking response with empty items list
  static const String emptyRankingJson = '''
{
  "items": []
}
''';

  /// Malformed ranking JSON
  static const String malformedRankingJson = '''
{
  "items": [
    {"recipeId": "rec_chicken_rice_bowl"
''';
}
