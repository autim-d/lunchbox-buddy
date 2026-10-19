// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lunchbox Buddy';

  @override
  String get appSubtitle =>
      'Your smart daily kitchen helper for school meals packed with love';

  @override
  String get welcomeTitle => 'Welcome to Lunchbox Buddy';

  @override
  String get welcomeSubtitle =>
      'Helping you decide what to cook and pack for your kids every day without the stress';

  @override
  String get homePlaceholderTitle => 'Today\'s Suggested Meals';

  @override
  String get homePlaceholderDescription =>
      'Here you\'ll discover 3 delicious meal ideas tailored for your kids and the ingredients you have';

  @override
  String get suggestMealButton => 'Suggest a meal';

  @override
  String get onboardingButton => 'Get Started';

  @override
  String get onboardingStepOneTitle => 'Add your children';

  @override
  String get onboardingStepOneDescription =>
      'Their ages, allergies, and dislikes so we pick what\'s best for them';

  @override
  String get goToOnboarding => 'Setup Kid Profiles';

  @override
  String get goToHome => 'Back to Home';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get currentLanguage => 'English';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get layoutDirectionLabel => 'Layout direction: Left to Right (LTR)';

  @override
  String get suggestIdeaOne => 'Cheese & cucumber sandwich with sliced apples';

  @override
  String get suggestIdeaTwo => 'Oat & banana mini pancakes';

  @override
  String get suggestIdeaThree =>
      'Grilled chicken tenders with carrots & hummus';

  @override
  String get debugRecipesTitle => 'Recipe Database (Debug)';

  @override
  String get debugRecipesSubtitle =>
      'Curated recipes stored locally in SQLite without network';

  @override
  String totalRecipesCount(int count) {
    return '$count Curated Recipes Stored Locally';
  }

  @override
  String prepMinutesLabel(int minutes) {
    return 'Prep: ${minutes}m';
  }

  @override
  String cookMinutesLabel(int minutes) {
    return 'Cook: ${minutes}m';
  }

  @override
  String ingredientsCountLabel(int count) {
    return '$count ingredients';
  }

  @override
  String stepsCountLabel(int count) {
    return '$count steps';
  }

  @override
  String get viewDebugRecipes => 'Browse Local Database Recipes (Debug)';

  @override
  String get loadingRecipes => 'Loading recipes from local database...';

  @override
  String get noRecipesFound => 'No recipes found in local database';

  @override
  String get allergenMilk => 'Milk & Dairy';

  @override
  String get allergenEgg => 'Eggs';

  @override
  String get allergenGluten => 'Wheat / Gluten';

  @override
  String get allergenNuts => 'Tree Nuts';

  @override
  String get allergenPeanuts => 'Peanuts';

  @override
  String get allergenSesame => 'Sesame';

  @override
  String get allergenFish => 'Fish';

  @override
  String get allergenShellfish => 'Shellfish';

  @override
  String get allergenSoy => 'Soy';

  @override
  String get noAllergies => 'No allergies';

  @override
  String get pickyLevel0 => 'Eats everything enthusiastically';

  @override
  String get pickyLevel1 => 'Slightly picky';

  @override
  String get pickyLevel2 => 'Moderately picky';

  @override
  String get pickyLevel3 => 'Very picky / particular';

  @override
  String get pickinessLabel => 'Food Pickiness Level';

  @override
  String get childNameLabel => 'Child\'s Name';

  @override
  String get childNameHint => 'e.g. Sarah, Faisal, Omar';

  @override
  String get childNameRequired => 'Please enter child\'s name';

  @override
  String get birthDateLabel => 'Birth Month & Year';

  @override
  String get birthMonth => 'Month';

  @override
  String get birthYear => 'Year';

  @override
  String get allergiesSectionTitle =>
      'Does your child have any food allergies?';

  @override
  String get dislikesSectionTitle => 'Foods or ingredients they dislike?';

  @override
  String get avatarSectionTitle => 'Choose an avatar and color';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String addChildSuccess(String name) {
    return '$name\'s profile saved successfully!';
  }

  @override
  String get addAnotherChild => 'Add Another Child';

  @override
  String get finishAndGoHome => 'Finish & Go to Home';

  @override
  String get kidsManagementTitle => 'My Children';

  @override
  String get kidsManagementSubtitle =>
      'Children dietary preferences and allergies';

  @override
  String get noKidsYet => 'No child profiles added yet';

  @override
  String get addNewChild => 'Add New Child';

  @override
  String get editChild => 'Edit Profile';

  @override
  String get deleteChildHoldPrompt => 'Hold to Delete';

  @override
  String get deleteChildHolding => 'Deleting...';

  @override
  String childDeletedMessage(String name) {
    return '$name\'s profile was deleted';
  }

  @override
  String get undoButton => 'Undo';

  @override
  String ageYearsMonths(int years) {
    return '$years years';
  }

  @override
  String ageMonthsOnly(int months) {
    return '$months months';
  }

  @override
  String get lunchboxTypeLabel => 'Preferred Lunchbox Type';

  @override
  String get lunchboxNone => 'Standard';

  @override
  String get lunchboxCold => 'Cold Pack';

  @override
  String get lunchboxHot => 'Insulated / Hot';

  @override
  String get myKidsSectionTitle => 'My Children';

  @override
  String get welcomeFeature1Title => 'Suggestions in 4 seconds';

  @override
  String get welcomeFeature1Subtitle => 'Zero morning stress or overthinking';

  @override
  String get welcomeFeature2Title => 'Deterministic Safety';

  @override
  String get welcomeFeature2Subtitle =>
      'Strict allergen and age-appropriate checks';

  @override
  String get dislikeCucumber => 'Cucumber';

  @override
  String get dislikeTomato => 'Tomato';

  @override
  String get dislikeCarrot => 'Carrot';

  @override
  String get dislikeBellPepper => 'Bell Pepper';

  @override
  String get dislikeOnion => 'Onion';

  @override
  String get dislikeGarlic => 'Garlic';

  @override
  String get dislikeTuna => 'Tuna';

  @override
  String get dislikePeas => 'Peas';

  @override
  String get dislikeOlives => 'Olives';

  @override
  String get dislikeFoul => 'Fava Beans';

  @override
  String get dislikeCorn => 'Corn';

  @override
  String get dislikeLettuce => 'Lettuce';

  @override
  String get editChildSubtitle => 'Update child preferences and dietary notes';

  @override
  String get noAllergiesSelected => 'No allergies selected';

  @override
  String get noDislikesSelected => 'No disliked foods selected';

  @override
  String get reasonIngredientsOnHand => 'You have most ingredients on hand';

  @override
  String get reasonKidFavorite => 'A favorite with your kids';

  @override
  String get reasonHiddenVeggies => 'Hidden veggies, great for picky eaters';

  @override
  String get reasonLunchboxFriendly => 'Perfect for school lunchboxes';

  @override
  String get reasonQuickPrep => 'Quick and easy prep';

  @override
  String get reasonBalancedMeal => 'Balanced and nutritious meal';

  @override
  String get testSuggestionsTitle => 'Test Suggestion Engine (Offline)';

  @override
  String get testSuggestionsDescription =>
      'Test deterministic safety filtering and recipe scoring';

  @override
  String get filterNutAllergy => 'Nut & Peanut Allergy';

  @override
  String get filterMilkAllergy => 'Dairy & Milk Allergy';

  @override
  String get filterGlutenAllergy => 'Gluten & Wheat Allergy';

  @override
  String get filterAllergiesNone => 'No Allergies';

  @override
  String get quickLunchboxTag => 'Quick School Lunchbox';

  @override
  String scoreLabel(String score) {
    return 'Score: $score';
  }

  @override
  String get topRecommendationsTitle => 'Top 3 Recommendations';

  @override
  String safeRecipesCount(int count) {
    return '$count Strictly Safe Recipes';
  }

  @override
  String get greetingMorning => 'Good morning, Mom';

  @override
  String get greetingAfternoon => 'Good afternoon, Mom';

  @override
  String get greetingEvening => 'Good evening, Mom';

  @override
  String get cookingForWhom => 'Cooking for whom?';

  @override
  String get allKidsOption => 'All my kids';

  @override
  String get savedRecipesSectionTitle => 'Saved Recipes';

  @override
  String get noSavedRecipesTitle => 'No saved recipes yet';

  @override
  String get noSavedRecipesSubtitle =>
      'Bookmark your children\'s favorite meals for quick access';

  @override
  String get suggestSheetTitle => 'Customize Meal';

  @override
  String get mealTypeSectionTitle => 'Meal Type';

  @override
  String get mealTypeBreakfast => 'Breakfast';

  @override
  String get mealTypeLunchbox => 'Lunchbox';

  @override
  String get mealTypeDinner => 'Dinner';

  @override
  String get mealTypeSnack => 'Snack';

  @override
  String get timeSectionTitle => 'Available Prep Time';

  @override
  String get time10Min => '10 min';

  @override
  String get time20Min => '20 min';

  @override
  String get time30PlusMin => '30+ min';

  @override
  String get moodSectionTitle => 'Today\'s Mood & Preference';

  @override
  String get moodPicky => 'Picky Eater';

  @override
  String get moodQuick => 'Quick & Light';

  @override
  String get moodFun => 'Fun & Creative';

  @override
  String get moodHiddenVeggies => 'Hidden Veggies';

  @override
  String get ingredientsOnHandTitle => 'Ingredients in your kitchen';

  @override
  String get ingredientsOnHandOptional => '(Optional)';

  @override
  String get searchIngredientsPlaceholder => 'Search ingredients...';

  @override
  String get notesFieldLabel => 'Notes or special requests';

  @override
  String get notesFieldPlaceholder =>
      'e.g., no raw onions, or something crispy...';

  @override
  String get micVoiceDisabledTooltip => 'Voice input will be available soon!';

  @override
  String get submitSuggestionButton => 'Suggest Meals Now';

  @override
  String get resultsScreenTitle => 'Meal Suggestions';

  @override
  String get resultsScreenSubtitle =>
      '3 tailored, allergen-safe ideas for your kids';

  @override
  String get ticketLabel => 'Meal Ticket';

  @override
  String totalMinutesFormat(int minutes) {
    return '$minutes mins';
  }

  @override
  String get cardActionDetails => 'Recipe Details';

  @override
  String get saveRecipeTooltip => 'Save to Favorites';

  @override
  String get unsaveRecipeTooltip => 'Remove from Favorites';

  @override
  String get emptyResultsTitle => 'No Matching Meals Found';

  @override
  String get emptyResultsMessage =>
      'Allergy constraints or tight prep time may have excluded all recipes. Try increasing prep time or adjusting filters.';

  @override
  String get adjustFiltersButton => 'Adjust Filters';

  @override
  String get errorResultsTitle => 'An Unexpected Error Occurred';

  @override
  String get retryButton => 'Retry';

  @override
  String cardCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String get recipeDetailTitle => 'Recipe Details';

  @override
  String get servingsLabel => 'Servings';

  @override
  String get ingredientsSectionTitle => 'Required Ingredients';

  @override
  String get stepsSectionTitle => 'Step-by-Step Preparation';

  @override
  String get iHaveThisIngredient => 'I have it';

  @override
  String ingredientsOnHandSummary(int haveCount, int totalCount) {
    return 'You have $haveCount of $totalCount';
  }

  @override
  String get addMissingToGrocery => 'Add missing to grocery list';

  @override
  String get missingAddedToGrocerySnackbar =>
      'Missing ingredients added to grocery list successfully!';

  @override
  String get startCooking => 'Start Cooking';

  @override
  String get dynamicSaveAction => 'Save Recipe';

  @override
  String get dynamicSavingAction => 'Saving...';

  @override
  String get dynamicSavedAction => 'Saved ✓';

  @override
  String get viewAllSavedRecipes => 'View All';

  @override
  String get recipeRemovedFromSaved => 'Recipe removed from favorites';

  @override
  String get undo => 'Undo';

  @override
  String get remove => 'Remove';

  @override
  String prepAndCookTime(int prep, int cook) {
    return 'Prep: ${prep}m • Cook: ${cook}m';
  }

  @override
  String stepNumberLabel(int number) {
    return 'Step $number';
  }

  @override
  String get optionalIngredient => '(Optional)';

  @override
  String get cookModeTitle => 'Cook Mode';

  @override
  String stepProgressLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get nextStepButton => 'Next Step';

  @override
  String get prevStepButton => 'Previous Step';

  @override
  String get finishCookingButton => 'Finish Cooking';

  @override
  String get exitCookModeTitle => 'Leave Cook Mode?';

  @override
  String get exitCookModeMessage =>
      'Are you sure you want to leave? Active timers will stop.';

  @override
  String get stayInCookMode => 'Keep Cooking';

  @override
  String get confirmExitCookMode => 'Exit';

  @override
  String get startTimer => 'Start Timer';

  @override
  String get pauseTimer => 'Pause';

  @override
  String get resumeTimer => 'Resume';

  @override
  String get resetTimer => 'Reset';

  @override
  String get timerFinished => 'Time\'s Up! 🔔';

  @override
  String get celebrationTitle => 'Well done, mom! 🌟';

  @override
  String get celebrationSubtitle =>
      'The meal is ready and delicious! Enjoy, kids!';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get feedbackPrompt => 'Did they eat it? Share their reaction:';

  @override
  String kidReactionPrompt(String kidName) {
    return '$kidName\'s reaction:';
  }

  @override
  String get reactionLoved => 'Loved it';

  @override
  String get reactionOk => 'It was OK';

  @override
  String get reactionRefused => 'Refused it';

  @override
  String get reasonPrompt => 'What was the reason? (optional)';

  @override
  String get reasonTooSpicy => 'Too spicy 🌶️';

  @override
  String get reasonTexture => 'Texture 🥣';

  @override
  String get reasonDislikedIngredient => 'Didn\'t like an ingredient 🥦';

  @override
  String get reasonNotHungry => 'Just not hungry ⏰';

  @override
  String get whichIngredientPrompt => 'Which ingredient didn\'t they like?';

  @override
  String get addDislikeConfirmTitle => 'Add to dislikes?';

  @override
  String addDislikeConfirmMessage(String ingredient, String kidName) {
    return 'Would you like to add $ingredient to $kidName\'s dislikes to avoid it in future suggestions?';
  }

  @override
  String get confirmAddDislike => 'Yes, add it';

  @override
  String get cancel => 'Cancel';

  @override
  String dislikeAddedSnackbar(String ingredient, String kidName) {
    return 'Added $ingredient to $kidName\'s dislikes';
  }

  @override
  String get feedbackSavedToast => 'Feedback saved, thank you! ✨';

  @override
  String get saveFeedbackAndDone => 'Save & Back to Home';

  @override
  String get kidsApprovedStamp => 'Kids Approved ✓';

  @override
  String get historyTitle => 'Meal History';

  @override
  String get historySubtitle => 'Past meals and kids\' reactions';

  @override
  String get emptyHistoryTitle => 'No meals logged yet';

  @override
  String get emptyHistorySubtitle =>
      'Cook and log your kids\' reactions to see them here';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int days) {
    return '$days days ago';
  }
}
