// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لانش بوكس بادي';

  @override
  String get appSubtitle =>
      'مساعدكِ اليومي لتحضير وجبات أطفالك المدرسية بكل حب وسهولة';

  @override
  String get welcomeTitle => 'أهلاً بكِ في لانش بوكس بادي';

  @override
  String get welcomeSubtitle =>
      'نساعدكِ تقررين وش تطبخين وتجهزين لأطفالك كل يوم بدون حيرة';

  @override
  String get homePlaceholderTitle => 'وجبات اليوم المقترحة';

  @override
  String get homePlaceholderDescription =>
      'هنا بتشوفين ٣ أفكار لوجبات شهية تناسب أطفالك ومكونات ثلاجتك';

  @override
  String get suggestMealButton => 'اقترحي لي وجبة';

  @override
  String get onboardingButton => 'ابدئي الآن';

  @override
  String get onboardingStepOneTitle => 'ضيفي أطفالك';

  @override
  String get onboardingStepOneDescription =>
      'أعمارهم، حساسياتهم، والأكلات اللي ما يحبونها عشان نختار لهم الأفضل';

  @override
  String get goToOnboarding => 'إعداد ملف الأطفال';

  @override
  String get goToHome => 'العودة للرئيسية';

  @override
  String get switchLanguage => 'تغيير اللغة';

  @override
  String get currentLanguage => 'العربية';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get layoutDirectionLabel => 'اتجاه العرض: من اليمين لليسار (RTL)';

  @override
  String get suggestIdeaOne => 'ساندوتش جبنة وخيار مع تفاح مقطع';

  @override
  String get suggestIdeaTwo => 'ميني بان كيك بالشوفان والموز';

  @override
  String get suggestIdeaThree => 'أصابع دجاج مشوية مع جزر وحمص';

  @override
  String get debugRecipesTitle => 'قاعدة بيانات الوصفات (محلياً)';

  @override
  String get debugRecipesSubtitle => 'وصفات معتمدة ومخزنة بدون اتصال بالإنترنت';

  @override
  String totalRecipesCount(int count) {
    return '$count وصفة معتمدة محلياً';
  }

  @override
  String prepMinutesLabel(int minutes) {
    return 'التحضير: $minutes د';
  }

  @override
  String cookMinutesLabel(int minutes) {
    return 'الطهي: $minutes د';
  }

  @override
  String ingredientsCountLabel(int count) {
    return '$count مكونات';
  }

  @override
  String stepsCountLabel(int count) {
    return '$count خطوات';
  }

  @override
  String get viewDebugRecipes => 'استعراض وصفات قاعدة البيانات المحلية (Debug)';

  @override
  String get loadingRecipes =>
      'جاري قراءة الوصفات من قاعدة البيانات المحلية...';

  @override
  String get noRecipesFound => 'لم يتم العثور على وصفات في قاعدة البيانات';

  @override
  String get allergenMilk => 'حليب ومشتقاته';

  @override
  String get allergenEgg => 'بيض';

  @override
  String get allergenGluten => 'قمح / جلوتين';

  @override
  String get allergenNuts => 'مكسرات';

  @override
  String get allergenPeanuts => 'فول سوداني';

  @override
  String get allergenSesame => 'سمسم';

  @override
  String get allergenFish => 'سمك';

  @override
  String get allergenShellfish => 'مأكولات بحرية';

  @override
  String get allergenSoy => 'صويا';

  @override
  String get noAllergies => 'لا توجد حساسيات';

  @override
  String get pickyLevel0 => 'يأكل كل شيء ما شاء الله';

  @override
  String get pickyLevel1 => 'انتقائي خفيف';

  @override
  String get pickyLevel2 => 'انتقائي معتدل';

  @override
  String get pickyLevel3 => 'انتقائي وصعب الإرضاء';

  @override
  String get pickinessLabel => 'درجة الانتقائية في الأكل';

  @override
  String get childNameLabel => 'اسم الطفل أو الطفلة';

  @override
  String get childNameHint => 'مثال: سارة، محمد، فيصل';

  @override
  String get childNameRequired => 'يرجى كتابة اسم الطفل';

  @override
  String get birthDateLabel => 'تاريخ وشهر الميلاد';

  @override
  String get birthMonth => 'الشهر';

  @override
  String get birthYear => 'السنة';

  @override
  String get allergiesSectionTitle => 'هل يعاني طفلكِ من أي حساسية طعام؟';

  @override
  String get dislikesSectionTitle => 'أكلات أو مكونات ما يحبها طفلكِ؟';

  @override
  String get avatarSectionTitle => 'اختاري شخصية ولوناً لطفلكِ';

  @override
  String get saveAndContinue => 'حفظ ومتابعة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String addChildSuccess(String name) {
    return 'تم حفظ ملف $name بنجاح!';
  }

  @override
  String get addAnotherChild => 'إضافة طفل آخر';

  @override
  String get finishAndGoHome => 'إتمام والذهاب للرئيسية';

  @override
  String get kidsManagementTitle => 'أطفالي';

  @override
  String get kidsManagementSubtitle => 'تفضيلات أطفالكِ الغذائية وحساسياتهم';

  @override
  String get noKidsYet => 'لم تقومي بإضافة أي طفل بعد';

  @override
  String get addNewChild => 'إضافة طفل جديد';

  @override
  String get editChild => 'تعديل الملف';

  @override
  String get deleteChildHoldPrompt => 'اضغطي مطولاً للحذف';

  @override
  String get deleteChildHolding => 'جاري الحذف...';

  @override
  String childDeletedMessage(String name) {
    return 'تم حذف ملف $name';
  }

  @override
  String get undoButton => 'تراجع';

  @override
  String ageYearsMonths(int years) {
    return '$years سنوات';
  }

  @override
  String ageMonthsOnly(int months) {
    return '$months أشهر';
  }

  @override
  String get lunchboxTypeLabel => 'نوع اللانش بوكس المفضل';

  @override
  String get lunchboxNone => 'عادي';

  @override
  String get lunchboxCold => 'يحفظ البرودة';

  @override
  String get lunchboxHot => 'حافظ للحرارة';

  @override
  String get myKidsSectionTitle => 'أطفالي المسجلين';

  @override
  String get welcomeFeature1Title => 'اقتراحات في 4 ثوانٍ';

  @override
  String get welcomeFeature1Subtitle => 'بدون تفكير أو حيرة صباحية';

  @override
  String get welcomeFeature2Title => 'حماية وأمان دقيق';

  @override
  String get welcomeFeature2Subtitle => 'فلترة حتمية للحساسيات والعمر';

  @override
  String get dislikeCucumber => 'خيار';

  @override
  String get dislikeTomato => 'طماطم';

  @override
  String get dislikeCarrot => 'جزر';

  @override
  String get dislikeBellPepper => 'فلفل رومي';

  @override
  String get dislikeOnion => 'بصل';

  @override
  String get dislikeGarlic => 'ثوم';

  @override
  String get dislikeTuna => 'تونة';

  @override
  String get dislikePeas => 'بازلاء';

  @override
  String get dislikeOlives => 'زيتون';

  @override
  String get dislikeFoul => 'فول';

  @override
  String get dislikeCorn => 'ذرة';

  @override
  String get dislikeLettuce => 'خس';

  @override
  String get editChildSubtitle => 'تحديث معلومات وتفضيلات طفلكِ';

  @override
  String get noAllergiesSelected => 'لا توجد حساسيات محددة';

  @override
  String get noDislikesSelected => 'لا توجد أكلات مستبعدة';

  @override
  String get reasonIngredientsOnHand => 'متوفر لديكِ أغلب المكونات';

  @override
  String get reasonKidFavorite => 'مفضلة ومحبوبة لأطفالكِ';

  @override
  String get reasonHiddenVeggies => 'خضار مخفية تناسب الانتقائيين';

  @override
  String get reasonLunchboxFriendly => 'مثالية للانش بوكس المدرسي';

  @override
  String get reasonQuickPrep => 'سريعة التحضير في وقت قياسي';

  @override
  String get reasonBalancedMeal => 'وجبة متوازنة ومغذية';

  @override
  String get testSuggestionsTitle => 'تجربة محرك الاقتراحات (بدون إنترنت)';

  @override
  String get testSuggestionsDescription =>
      'اختبار الفلترة الحتمية للحساسيات وترتيب الوجبات';

  @override
  String get filterNutAllergy => 'حساسية المكسرات والفول السوداني';

  @override
  String get filterMilkAllergy => 'حساسية الحليب ومشتقاته';

  @override
  String get filterGlutenAllergy => 'حساسية القمح والجلوتين';

  @override
  String get filterAllergiesNone => 'بدون حساسيات';

  @override
  String get quickLunchboxTag => 'لانش بوكس مدرسي سريع';

  @override
  String scoreLabel(String score) {
    return 'التقييم: $score';
  }

  @override
  String get topRecommendationsTitle => 'أفضل 3 اقتراحات';

  @override
  String safeRecipesCount(int count) {
    return '$count وصفة آمنة تماماً';
  }

  @override
  String get greetingMorning => 'صباح الخير يا أمي';

  @override
  String get greetingAfternoon => 'مساء الخير يا أمي';

  @override
  String get greetingEvening => 'مساء الورد يا أمي';

  @override
  String get cookingForWhom => 'تجهيز وجبة لمن؟';

  @override
  String get allKidsOption => 'كل أطفالي';

  @override
  String get savedRecipesSectionTitle => 'الوصفات المحفوظة';

  @override
  String get noSavedRecipesTitle => 'لا توجد وصفات محفوظة بعد';

  @override
  String get noSavedRecipesSubtitle =>
      'احفظي وجبات أطفالكِ المفضلة للرجوع إليها سريعاً';

  @override
  String get suggestSheetTitle => 'تخصيص الوجبة';

  @override
  String get mealTypeSectionTitle => 'نوع الوجبة';

  @override
  String get mealTypeBreakfast => 'فطور';

  @override
  String get mealTypeLunchbox => 'لانش بوكس';

  @override
  String get mealTypeDinner => 'عشاء';

  @override
  String get mealTypeSnack => 'سناك';

  @override
  String get timeSectionTitle => 'الوقت المتاح للتحضير';

  @override
  String get time10Min => '١٠ دقائق';

  @override
  String get time20Min => '٢٠ دقيقة';

  @override
  String get time30PlusMin => '٣٠+ دقيقة';

  @override
  String get moodSectionTitle => 'مزاج اليوم والوجبة';

  @override
  String get moodPicky => 'للطفل الانتقائي';

  @override
  String get moodQuick => 'سريع وخفيف';

  @override
  String get moodFun => 'ممتع ومرح';

  @override
  String get moodHiddenVeggies => 'خضار مخفية';

  @override
  String get ingredientsOnHandTitle => 'مكونات متوفرة في مطبخكِ';

  @override
  String get ingredientsOnHandOptional => '(اختياري)';

  @override
  String get searchIngredientsPlaceholder => 'ابحثي عن مكون...';

  @override
  String get notesFieldLabel => 'ملاحظة أو تفضيل خاص';

  @override
  String get notesFieldPlaceholder => 'مثال: بدون بصل، أو شيء مقرمش...';

  @override
  String get micVoiceDisabledTooltip => 'التسجيل الصوتي سيكون متاحاً قريباً!';

  @override
  String get submitSuggestionButton => 'اقترحي الوجبات الآن';

  @override
  String get resultsScreenTitle => 'اقتراحات الوجبات';

  @override
  String get resultsScreenSubtitle => '٣ أفكار مدروسة وآمنة لأطفالكِ';

  @override
  String get ticketLabel => 'تذكرة وجبة';

  @override
  String totalMinutesFormat(int minutes) {
    return '$minutes دقيقة';
  }

  @override
  String get cardActionDetails => 'طريقة التحضير';

  @override
  String get saveRecipeTooltip => 'حفظ في المفضلة';

  @override
  String get unsaveRecipeTooltip => 'إزالة من المفضلة';

  @override
  String get emptyResultsTitle => 'لم نعثر على وجبة مطابقة تماماً';

  @override
  String get emptyResultsMessage =>
      'حساسيات الأطفال أو ضيق الوقت استبعدت بعض الوصفات. جربي زيادة الوقت أو اختيار فلاتر أخرى.';

  @override
  String get adjustFiltersButton => 'تعديل الفلاتر';

  @override
  String get errorResultsTitle => 'حدث خطأ غير متوقع';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String cardCounter(int current, int total) {
    return '$current من $total';
  }

  @override
  String get recipeDetailTitle => 'تفاصيل الوصفة';

  @override
  String get servingsLabel => 'عدد الحصص';

  @override
  String get ingredientsSectionTitle => 'المكونات المطلوبة';

  @override
  String get stepsSectionTitle => 'طريقة التحضير خطوة بخطوة';

  @override
  String get iHaveThisIngredient => 'متوفر لدي';

  @override
  String ingredientsOnHandSummary(int haveCount, int totalCount) {
    return 'المتوفر لديكِ: $haveCount من $totalCount';
  }

  @override
  String get addMissingToGrocery => 'إضافة النواقص لقائمة التسوق';

  @override
  String get missingAddedToGrocerySnackbar =>
      'تمت إضافة المكونات الناقصة إلى قائمة التسوق بنجاح!';

  @override
  String get startCooking => 'ابدأي الطهي';

  @override
  String get dynamicSaveAction => 'حفظ الوصفة';

  @override
  String get dynamicSavingAction => 'جاري الحفظ...';

  @override
  String get dynamicSavedAction => 'تم الحفظ ✓';

  @override
  String get viewAllSavedRecipes => 'عرض الكل';

  @override
  String get recipeRemovedFromSaved => 'تمت إزالة الوصفة من المفضلة';

  @override
  String get undo => 'تراجع';

  @override
  String get remove => 'حذف';

  @override
  String prepAndCookTime(int prep, int cook) {
    return 'التحضير: $prep د • الطهي: $cook د';
  }

  @override
  String stepNumberLabel(int number) {
    return 'خطوة $number';
  }

  @override
  String get optionalIngredient => '(اختياري)';

  @override
  String get cookModeTitle => 'وضع الطهي';

  @override
  String stepProgressLabel(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get nextStepButton => 'الخطوة التالية';

  @override
  String get prevStepButton => 'الخطوة السابقة';

  @override
  String get finishCookingButton => 'إتمام الطهي';

  @override
  String get exitCookModeTitle => 'مغادرة وضع الطهي؟';

  @override
  String get exitCookModeMessage =>
      'هل أنتِ متأكدة من المغادرة؟ ستتوقف المؤقتات النشطة.';

  @override
  String get stayInCookMode => 'متابعة الطهي';

  @override
  String get confirmExitCookMode => 'خروج';

  @override
  String get startTimer => 'بدء المؤقت';

  @override
  String get pauseTimer => 'إيقاف مؤقت';

  @override
  String get resumeTimer => 'استئناف';

  @override
  String get resetTimer => 'إعادة ضبط';

  @override
  String get timerFinished => 'انتهى الوقت! 🔔';

  @override
  String get celebrationTitle => 'تسلم الأيادي يا أمي! 🌟';

  @override
  String get celebrationSubtitle =>
      'الوجبة جاهزة ولذيذة، بالهناء والشفاء لأطفالكِ!';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get feedbackPrompt => 'هل أكلوها؟ شاركينا رأيهم:';

  @override
  String kidReactionPrompt(String kidName) {
    return 'رأي $kidName في الوجبة:';
  }

  @override
  String get reactionLoved => 'أحبها';

  @override
  String get reactionOk => 'عادية';

  @override
  String get reactionRefused => 'رفضها';

  @override
  String get reasonPrompt => 'ما السبب؟ (اختياري)';

  @override
  String get reasonTooSpicy => 'حار جداً 🌶️';

  @override
  String get reasonTexture => 'القوام 🥣';

  @override
  String get reasonDislikedIngredient => 'مكون ما عجبه 🥦';

  @override
  String get reasonNotHungry => 'ما كان جيعان ⏰';

  @override
  String get whichIngredientPrompt => 'أي مكون لم يعجبه؟';

  @override
  String get addDislikeConfirmTitle => 'إضافة إلى غير المفضلة؟';

  @override
  String addDislikeConfirmMessage(String ingredient, String kidName) {
    return 'هل ترغبين في إضافة $ingredient إلى قائمة المكونات غير المفضلة لـ $kidName لتجنبها مستقبلاً؟';
  }

  @override
  String get confirmAddDislike => 'نعم، أضيفيها';

  @override
  String get cancel => 'إلغاء';

  @override
  String dislikeAddedSnackbar(String ingredient, String kidName) {
    return 'تمت إضافة $ingredient إلى غير المفضلة لـ $kidName';
  }

  @override
  String get feedbackSavedToast => 'تم حفظ رأيكِ، شكراً لكِ! ✨';

  @override
  String get saveFeedbackAndDone => 'حفظ والعودة للرئيسية';

  @override
  String get kidsApprovedStamp => 'معتمد من الصغار ✓';

  @override
  String get historyTitle => 'سجل الوجبات';

  @override
  String get historySubtitle => 'الوجبات السابقة وردود أفعال الصغار';

  @override
  String get emptyHistoryTitle => 'لا توجد وجبات مسجلة بعد';

  @override
  String get emptyHistorySubtitle => 'اطبخي وسجلي رأي أطفالك لتظهر الوجبات هنا';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int days) {
    return 'منذ $days أيام';
  }

  @override
  String get groceryTitle => 'قائمة التسوق';

  @override
  String get grocerySubtitle => 'مكونات منظمة لسهولة التسوق';

  @override
  String get emptyGroceryTitle => 'قائمة التسوق فارغة';

  @override
  String get emptyGrocerySubtitle =>
      'أضيفي المكونات الناقصة من أي وصفة أو سجلي أغراضكِ يدوياً';

  @override
  String get addCustomItem => 'إضافة غرض';

  @override
  String get addItemTitle => 'إضافة غرض جديد';

  @override
  String get itemNameLabel => 'اسم المكون أو الغرض';

  @override
  String get itemQuantityLabel => 'الكمية (اختياري)';

  @override
  String get itemUnitLabel => 'الوحدة (اختياري)';

  @override
  String get itemAisleLabel => 'القسم في السوبرماركت';

  @override
  String get shareList => 'مشاركة القائمة';

  @override
  String get shareListWhatsApp => 'مشاركة عبر واتساب';

  @override
  String get clearCheckedItems => 'مسح المكتمل';

  @override
  String get clearAllItems => 'مسح الكل';

  @override
  String get itemDeleted => 'تم حذف الغرض';

  @override
  String itemsAddedToGrocery(int count) {
    return 'تمت إضافة $count من المكونات لقائمة التسوق';
  }

  @override
  String get viewGroceryList => 'عرض القائمة';

  @override
  String get printReceipt => 'طباعة الفاتورة';

  @override
  String get receiptStoreName => 'لانش بوكس بادي';

  @override
  String get receiptTagline => 'قائمة تسوق طازجة لطبخات الصغار';

  @override
  String get confirmClearAllTitle => 'مسح قائمة التسوق بالكامل؟';

  @override
  String get confirmClearAllMessage =>
      'هل أنتِ متأكدة من رغبتك في حذف جميع الأغراض من قائمة التسوق؟';
}
