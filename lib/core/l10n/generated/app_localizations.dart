import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In ar, this message translates to:
  /// **'لانش بوكس بادي'**
  String get appTitle;

  /// Tagline or subtitle of the application
  ///
  /// In ar, this message translates to:
  /// **'مساعدكِ اليومي لتحضير وجبات أطفالك المدرسية بكل حب وسهولة'**
  String get appSubtitle;

  /// Welcome title in onboarding
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بكِ في لانش بوكس بادي'**
  String get welcomeTitle;

  /// Saudi-friendly friendly onboarding subtitle
  ///
  /// In ar, this message translates to:
  /// **'نساعدكِ تقررين وش تطبخين وتجهزين لأطفالك كل يوم بدون حيرة'**
  String get welcomeSubtitle;

  /// Title on the placeholder home screen
  ///
  /// In ar, this message translates to:
  /// **'وجبات اليوم المقترحة'**
  String get homePlaceholderTitle;

  /// Description on the placeholder home screen
  ///
  /// In ar, this message translates to:
  /// **'هنا بتشوفين ٣ أفكار لوجبات شهية تناسب أطفالك ومكونات ثلاجتك'**
  String get homePlaceholderDescription;

  /// Primary tactile action button to suggest a meal
  ///
  /// In ar, this message translates to:
  /// **'اقترحي لي وجبة'**
  String get suggestMealButton;

  /// Get started button on onboarding
  ///
  /// In ar, this message translates to:
  /// **'ابدئي الآن'**
  String get onboardingButton;

  /// Onboarding step title for adding children
  ///
  /// In ar, this message translates to:
  /// **'ضيفي أطفالك'**
  String get onboardingStepOneTitle;

  /// Onboarding step description
  ///
  /// In ar, this message translates to:
  /// **'أعمارهم، حساسياتهم، والأكلات اللي ما يحبونها عشان نختار لهم الأفضل'**
  String get onboardingStepOneDescription;

  /// Button to navigate to onboarding
  ///
  /// In ar, this message translates to:
  /// **'إعداد ملف الأطفال'**
  String get goToOnboarding;

  /// Button to navigate back to home
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get goToHome;

  /// Button or label to toggle app language
  ///
  /// In ar, this message translates to:
  /// **'تغيير اللغة'**
  String get switchLanguage;

  /// Name of the current language
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get currentLanguage;

  /// English language name
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language name
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// Label indicating layout direction
  ///
  /// In ar, this message translates to:
  /// **'اتجاه العرض: من اليمين لليسار (RTL)'**
  String get layoutDirectionLabel;

  /// Sample meal idea 1
  ///
  /// In ar, this message translates to:
  /// **'ساندوتش جبنة وخيار مع تفاح مقطع'**
  String get suggestIdeaOne;

  /// Sample meal idea 2
  ///
  /// In ar, this message translates to:
  /// **'ميني بان كيك بالشوفان والموز'**
  String get suggestIdeaTwo;

  /// Sample meal idea 3
  ///
  /// In ar, this message translates to:
  /// **'أصابع دجاج مشوية مع جزر وحمص'**
  String get suggestIdeaThree;

  /// Title of debug recipes screen
  ///
  /// In ar, this message translates to:
  /// **'قاعدة بيانات الوصفات (محلياً)'**
  String get debugRecipesTitle;

  /// Subtitle of debug recipes screen
  ///
  /// In ar, this message translates to:
  /// **'وصفات معتمدة ومخزنة بدون اتصال بالإنترنت'**
  String get debugRecipesSubtitle;

  /// Total recipes count banner
  ///
  /// In ar, this message translates to:
  /// **'{count} وصفة معتمدة محلياً'**
  String totalRecipesCount(int count);

  /// Preparation time label
  ///
  /// In ar, this message translates to:
  /// **'التحضير: {minutes} د'**
  String prepMinutesLabel(int minutes);

  /// Cooking time label
  ///
  /// In ar, this message translates to:
  /// **'الطهي: {minutes} د'**
  String cookMinutesLabel(int minutes);

  /// Number of ingredients in a recipe
  ///
  /// In ar, this message translates to:
  /// **'{count} مكونات'**
  String ingredientsCountLabel(int count);

  /// Number of steps in a recipe
  ///
  /// In ar, this message translates to:
  /// **'{count} خطوات'**
  String stepsCountLabel(int count);

  /// Button to open debug recipes list
  ///
  /// In ar, this message translates to:
  /// **'استعراض وصفات قاعدة البيانات المحلية (Debug)'**
  String get viewDebugRecipes;

  /// Loading state label
  ///
  /// In ar, this message translates to:
  /// **'جاري قراءة الوصفات من قاعدة البيانات المحلية...'**
  String get loadingRecipes;

  /// Empty state label
  ///
  /// In ar, this message translates to:
  /// **'لم يتم العثور على وصفات في قاعدة البيانات'**
  String get noRecipesFound;

  /// Milk allergen
  ///
  /// In ar, this message translates to:
  /// **'حليب ومشتقاته'**
  String get allergenMilk;

  /// Egg allergen
  ///
  /// In ar, this message translates to:
  /// **'بيض'**
  String get allergenEgg;

  /// Gluten allergen
  ///
  /// In ar, this message translates to:
  /// **'قمح / جلوتين'**
  String get allergenGluten;

  /// Tree nuts allergen
  ///
  /// In ar, this message translates to:
  /// **'مكسرات'**
  String get allergenNuts;

  /// Peanut allergen
  ///
  /// In ar, this message translates to:
  /// **'فول سوداني'**
  String get allergenPeanuts;

  /// Sesame allergen
  ///
  /// In ar, this message translates to:
  /// **'سمسم'**
  String get allergenSesame;

  /// Fish allergen
  ///
  /// In ar, this message translates to:
  /// **'سمك'**
  String get allergenFish;

  /// Shellfish allergen
  ///
  /// In ar, this message translates to:
  /// **'مأكولات بحرية'**
  String get allergenShellfish;

  /// Soy allergen
  ///
  /// In ar, this message translates to:
  /// **'صويا'**
  String get allergenSoy;

  /// No allergies option
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حساسيات'**
  String get noAllergies;

  /// Picky level 0
  ///
  /// In ar, this message translates to:
  /// **'يأكل كل شيء ما شاء الله'**
  String get pickyLevel0;

  /// Picky level 1
  ///
  /// In ar, this message translates to:
  /// **'انتقائي خفيف'**
  String get pickyLevel1;

  /// Picky level 2
  ///
  /// In ar, this message translates to:
  /// **'انتقائي معتدل'**
  String get pickyLevel2;

  /// Picky level 3
  ///
  /// In ar, this message translates to:
  /// **'انتقائي وصعب الإرضاء'**
  String get pickyLevel3;

  /// Pickiness label
  ///
  /// In ar, this message translates to:
  /// **'درجة الانتقائية في الأكل'**
  String get pickinessLabel;

  /// Child name label
  ///
  /// In ar, this message translates to:
  /// **'اسم الطفل أو الطفلة'**
  String get childNameLabel;

  /// Child name hint
  ///
  /// In ar, this message translates to:
  /// **'مثال: سارة، محمد، فيصل'**
  String get childNameHint;

  /// Child name required error
  ///
  /// In ar, this message translates to:
  /// **'يرجى كتابة اسم الطفل'**
  String get childNameRequired;

  /// Birth date label
  ///
  /// In ar, this message translates to:
  /// **'تاريخ وشهر الميلاد'**
  String get birthDateLabel;

  /// Month
  ///
  /// In ar, this message translates to:
  /// **'الشهر'**
  String get birthMonth;

  /// Year
  ///
  /// In ar, this message translates to:
  /// **'السنة'**
  String get birthYear;

  /// Allergies section title
  ///
  /// In ar, this message translates to:
  /// **'هل يعاني طفلكِ من أي حساسية طعام؟'**
  String get allergiesSectionTitle;

  /// Dislikes section title
  ///
  /// In ar, this message translates to:
  /// **'أكلات أو مكونات ما يحبها طفلكِ؟'**
  String get dislikesSectionTitle;

  /// Avatar section title
  ///
  /// In ar, this message translates to:
  /// **'اختاري شخصية ولوناً لطفلكِ'**
  String get avatarSectionTitle;

  /// Save and continue button
  ///
  /// In ar, this message translates to:
  /// **'حفظ ومتابعة'**
  String get saveAndContinue;

  /// Save changes button
  ///
  /// In ar, this message translates to:
  /// **'حفظ التعديلات'**
  String get saveChanges;

  /// Child added success banner
  ///
  /// In ar, this message translates to:
  /// **'تم حفظ ملف {name} بنجاح!'**
  String addChildSuccess(String name);

  /// Add another child button
  ///
  /// In ar, this message translates to:
  /// **'إضافة طفل آخر'**
  String get addAnotherChild;

  /// Finish onboarding button
  ///
  /// In ar, this message translates to:
  /// **'إتمام والذهاب للرئيسية'**
  String get finishAndGoHome;

  /// Kids management title
  ///
  /// In ar, this message translates to:
  /// **'أطفالي'**
  String get kidsManagementTitle;

  /// Kids management subtitle
  ///
  /// In ar, this message translates to:
  /// **'تفضيلات أطفالكِ الغذائية وحساسياتهم'**
  String get kidsManagementSubtitle;

  /// No kids empty message
  ///
  /// In ar, this message translates to:
  /// **'لم تقومي بإضافة أي طفل بعد'**
  String get noKidsYet;

  /// Add new child button
  ///
  /// In ar, this message translates to:
  /// **'إضافة طفل جديد'**
  String get addNewChild;

  /// Edit child button
  ///
  /// In ar, this message translates to:
  /// **'تعديل الملف'**
  String get editChild;

  /// Hold to delete prompt
  ///
  /// In ar, this message translates to:
  /// **'اضغطي مطولاً للحذف'**
  String get deleteChildHoldPrompt;

  /// Deleting progress prompt
  ///
  /// In ar, this message translates to:
  /// **'جاري الحذف...'**
  String get deleteChildHolding;

  /// Child deleted snackbar message
  ///
  /// In ar, this message translates to:
  /// **'تم حذف ملف {name}'**
  String childDeletedMessage(String name);

  /// Undo button
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undoButton;

  /// Age in years
  ///
  /// In ar, this message translates to:
  /// **'{years} سنوات'**
  String ageYearsMonths(int years);

  /// Age in months
  ///
  /// In ar, this message translates to:
  /// **'{months} أشهر'**
  String ageMonthsOnly(int months);

  /// Lunchbox type label
  ///
  /// In ar, this message translates to:
  /// **'نوع اللانش بوكس المفضل'**
  String get lunchboxTypeLabel;

  /// Standard lunchbox
  ///
  /// In ar, this message translates to:
  /// **'عادي'**
  String get lunchboxNone;

  /// Cold pack lunchbox
  ///
  /// In ar, this message translates to:
  /// **'يحفظ البرودة'**
  String get lunchboxCold;

  /// Thermos lunchbox
  ///
  /// In ar, this message translates to:
  /// **'حافظ للحرارة'**
  String get lunchboxHot;

  /// Section header for registered kids on home
  ///
  /// In ar, this message translates to:
  /// **'أطفالي المسجلين'**
  String get myKidsSectionTitle;

  /// Welcome feature 1 title
  ///
  /// In ar, this message translates to:
  /// **'اقتراحات في 4 ثوانٍ'**
  String get welcomeFeature1Title;

  /// Welcome feature 1 subtitle
  ///
  /// In ar, this message translates to:
  /// **'بدون تفكير أو حيرة صباحية'**
  String get welcomeFeature1Subtitle;

  /// Welcome feature 2 title
  ///
  /// In ar, this message translates to:
  /// **'حماية وأمان دقيق'**
  String get welcomeFeature2Title;

  /// Welcome feature 2 subtitle
  ///
  /// In ar, this message translates to:
  /// **'فلترة حتمية للحساسيات والعمر'**
  String get welcomeFeature2Subtitle;

  /// Cucumber dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'خيار'**
  String get dislikeCucumber;

  /// Tomato dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'طماطم'**
  String get dislikeTomato;

  /// Carrot dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'جزر'**
  String get dislikeCarrot;

  /// Bell pepper dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'فلفل رومي'**
  String get dislikeBellPepper;

  /// Onion dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'بصل'**
  String get dislikeOnion;

  /// Garlic dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'ثوم'**
  String get dislikeGarlic;

  /// Tuna dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'تونة'**
  String get dislikeTuna;

  /// Peas dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'بازلاء'**
  String get dislikePeas;

  /// Olives dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'زيتون'**
  String get dislikeOlives;

  /// Foul dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'فول'**
  String get dislikeFoul;

  /// Corn dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'ذرة'**
  String get dislikeCorn;

  /// Lettuce dislike chip label
  ///
  /// In ar, this message translates to:
  /// **'خس'**
  String get dislikeLettuce;

  /// Subtitle for edit child bottom sheet
  ///
  /// In ar, this message translates to:
  /// **'تحديث معلومات وتفضيلات طفلكِ'**
  String get editChildSubtitle;

  /// Empty allergies label
  ///
  /// In ar, this message translates to:
  /// **'لا توجد حساسيات محددة'**
  String get noAllergiesSelected;

  /// Empty dislikes label
  ///
  /// In ar, this message translates to:
  /// **'لا توجد أكلات مستبعدة'**
  String get noDislikesSelected;

  /// Suggestion reason: ingredients on hand
  ///
  /// In ar, this message translates to:
  /// **'متوفر لديكِ أغلب المكونات'**
  String get reasonIngredientsOnHand;

  /// Suggestion reason: kid favorite
  ///
  /// In ar, this message translates to:
  /// **'مفضلة ومحبوبة لأطفالكِ'**
  String get reasonKidFavorite;

  /// Suggestion reason: hidden veggies
  ///
  /// In ar, this message translates to:
  /// **'خضار مخفية تناسب الانتقائيين'**
  String get reasonHiddenVeggies;

  /// Suggestion reason: lunchbox friendly
  ///
  /// In ar, this message translates to:
  /// **'مثالية للانش بوكس المدرسي'**
  String get reasonLunchboxFriendly;

  /// Suggestion reason: quick prep
  ///
  /// In ar, this message translates to:
  /// **'سريعة التحضير في وقت قياسي'**
  String get reasonQuickPrep;

  /// Suggestion reason: balanced meal
  ///
  /// In ar, this message translates to:
  /// **'وجبة متوازنة ومغذية'**
  String get reasonBalancedMeal;

  /// Title for test suggestions tab
  ///
  /// In ar, this message translates to:
  /// **'تجربة محرك الاقتراحات (بدون إنترنت)'**
  String get testSuggestionsTitle;

  /// Subtitle for test suggestions tab
  ///
  /// In ar, this message translates to:
  /// **'اختبار الفلترة الحتمية للحساسيات وترتيب الوجبات'**
  String get testSuggestionsDescription;

  /// Test nut allergy chip
  ///
  /// In ar, this message translates to:
  /// **'حساسية المكسرات والفول السوداني'**
  String get filterNutAllergy;

  /// Test milk allergy chip
  ///
  /// In ar, this message translates to:
  /// **'حساسية الحليب ومشتقاته'**
  String get filterMilkAllergy;

  /// Test gluten allergy chip
  ///
  /// In ar, this message translates to:
  /// **'حساسية القمح والجلوتين'**
  String get filterGlutenAllergy;

  /// No allergies chip
  ///
  /// In ar, this message translates to:
  /// **'بدون حساسيات'**
  String get filterAllergiesNone;

  /// Quick lunchbox test preset
  ///
  /// In ar, this message translates to:
  /// **'لانش بوكس مدرسي سريع'**
  String get quickLunchboxTag;

  /// Score label for recommendation card
  ///
  /// In ar, this message translates to:
  /// **'التقييم: {score}'**
  String scoreLabel(String score);

  /// Top 3 recommendations title
  ///
  /// In ar, this message translates to:
  /// **'أفضل 3 اقتراحات'**
  String get topRecommendationsTitle;

  /// Count of safe recipes after filter
  ///
  /// In ar, this message translates to:
  /// **'{count} وصفة آمنة تماماً'**
  String safeRecipesCount(int count);

  /// Morning greeting on home screen
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير يا أمي'**
  String get greetingMorning;

  /// Afternoon greeting on home screen
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير يا أمي'**
  String get greetingAfternoon;

  /// Evening greeting on home screen
  ///
  /// In ar, this message translates to:
  /// **'مساء الورد يا أمي'**
  String get greetingEvening;

  /// Kid selector title on home screen
  ///
  /// In ar, this message translates to:
  /// **'تجهيز وجبة لمن؟'**
  String get cookingForWhom;

  /// Option to select all kids
  ///
  /// In ar, this message translates to:
  /// **'كل أطفالي'**
  String get allKidsOption;

  /// Saved recipes title on home screen
  ///
  /// In ar, this message translates to:
  /// **'الوصفات المحفوظة'**
  String get savedRecipesSectionTitle;

  /// Title when no recipes are saved
  ///
  /// In ar, this message translates to:
  /// **'لا توجد وصفات محفوظة بعد'**
  String get noSavedRecipesTitle;

  /// Subtitle when no recipes are saved
  ///
  /// In ar, this message translates to:
  /// **'احفظي وجبات أطفالكِ المفضلة للرجوع إليها سريعاً'**
  String get noSavedRecipesSubtitle;

  /// Title for suggest bottom sheet
  ///
  /// In ar, this message translates to:
  /// **'تخصيص الوجبة'**
  String get suggestSheetTitle;

  /// Meal type section title
  ///
  /// In ar, this message translates to:
  /// **'نوع الوجبة'**
  String get mealTypeSectionTitle;

  /// Breakfast meal type
  ///
  /// In ar, this message translates to:
  /// **'فطور'**
  String get mealTypeBreakfast;

  /// Lunchbox meal type
  ///
  /// In ar, this message translates to:
  /// **'لانش بوكس'**
  String get mealTypeLunchbox;

  /// Dinner meal type
  ///
  /// In ar, this message translates to:
  /// **'عشاء'**
  String get mealTypeDinner;

  /// Snack meal type
  ///
  /// In ar, this message translates to:
  /// **'سناك'**
  String get mealTypeSnack;

  /// Time section title
  ///
  /// In ar, this message translates to:
  /// **'الوقت المتاح للتحضير'**
  String get timeSectionTitle;

  /// 10 minutes option
  ///
  /// In ar, this message translates to:
  /// **'١٠ دقائق'**
  String get time10Min;

  /// 20 minutes option
  ///
  /// In ar, this message translates to:
  /// **'٢٠ دقيقة'**
  String get time20Min;

  /// 30+ minutes option
  ///
  /// In ar, this message translates to:
  /// **'٣٠+ دقيقة'**
  String get time30PlusMin;

  /// Mood section title
  ///
  /// In ar, this message translates to:
  /// **'مزاج اليوم والوجبة'**
  String get moodSectionTitle;

  /// Picky mood option
  ///
  /// In ar, this message translates to:
  /// **'للطفل الانتقائي'**
  String get moodPicky;

  /// Quick mood option
  ///
  /// In ar, this message translates to:
  /// **'سريع وخفيف'**
  String get moodQuick;

  /// Fun mood option
  ///
  /// In ar, this message translates to:
  /// **'ممتع ومرح'**
  String get moodFun;

  /// Hidden veggies mood option
  ///
  /// In ar, this message translates to:
  /// **'خضار مخفية'**
  String get moodHiddenVeggies;

  /// Ingredients on hand title
  ///
  /// In ar, this message translates to:
  /// **'مكونات متوفرة في مطبخكِ'**
  String get ingredientsOnHandTitle;

  /// Optional label
  ///
  /// In ar, this message translates to:
  /// **'(اختياري)'**
  String get ingredientsOnHandOptional;

  /// Placeholder for ingredients search
  ///
  /// In ar, this message translates to:
  /// **'ابحثي عن مكون...'**
  String get searchIngredientsPlaceholder;

  /// Notes field label
  ///
  /// In ar, this message translates to:
  /// **'ملاحظة أو تفضيل خاص'**
  String get notesFieldLabel;

  /// Notes field placeholder
  ///
  /// In ar, this message translates to:
  /// **'مثال: بدون بصل، أو شيء مقرمش...'**
  String get notesFieldPlaceholder;

  /// Disabled mic tooltip
  ///
  /// In ar, this message translates to:
  /// **'التسجيل الصوتي سيكون متاحاً قريباً!'**
  String get micVoiceDisabledTooltip;

  /// Submit suggestion CTA button
  ///
  /// In ar, this message translates to:
  /// **'اقترحي الوجبات الآن'**
  String get submitSuggestionButton;

  /// Results screen title
  ///
  /// In ar, this message translates to:
  /// **'اقتراحات الوجبات'**
  String get resultsScreenTitle;

  /// Results screen subtitle
  ///
  /// In ar, this message translates to:
  /// **'٣ أفكار مدروسة وآمنة لأطفالكِ'**
  String get resultsScreenSubtitle;

  /// Meal ticket label
  ///
  /// In ar, this message translates to:
  /// **'تذكرة وجبة'**
  String get ticketLabel;

  /// Formatted total minutes
  ///
  /// In ar, this message translates to:
  /// **'{minutes} دقيقة'**
  String totalMinutesFormat(int minutes);

  /// Action on recipe card
  ///
  /// In ar, this message translates to:
  /// **'طريقة التحضير'**
  String get cardActionDetails;

  /// Save recipe tooltip
  ///
  /// In ar, this message translates to:
  /// **'حفظ في المفضلة'**
  String get saveRecipeTooltip;

  /// Unsave recipe tooltip
  ///
  /// In ar, this message translates to:
  /// **'إزالة من المفضلة'**
  String get unsaveRecipeTooltip;

  /// Empty results title
  ///
  /// In ar, this message translates to:
  /// **'لم نعثر على وجبة مطابقة تماماً'**
  String get emptyResultsTitle;

  /// Empty results description
  ///
  /// In ar, this message translates to:
  /// **'حساسيات الأطفال أو ضيق الوقت استبعدت بعض الوصفات. جربي زيادة الوقت أو اختيار فلاتر أخرى.'**
  String get emptyResultsMessage;

  /// Adjust filters button
  ///
  /// In ar, this message translates to:
  /// **'تعديل الفلاتر'**
  String get adjustFiltersButton;

  /// Error results title
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get errorResultsTitle;

  /// Retry button
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retryButton;

  /// Card counter in results screen
  ///
  /// In ar, this message translates to:
  /// **'{current} من {total}'**
  String cardCounter(int current, int total);

  /// Recipe detail app bar title
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوصفة'**
  String get recipeDetailTitle;

  /// Servings stepper label
  ///
  /// In ar, this message translates to:
  /// **'عدد الحصص'**
  String get servingsLabel;

  /// Required ingredients section title
  ///
  /// In ar, this message translates to:
  /// **'المكونات المطلوبة'**
  String get ingredientsSectionTitle;

  /// Step by step preparation section title
  ///
  /// In ar, this message translates to:
  /// **'طريقة التحضير خطوة بخطوة'**
  String get stepsSectionTitle;

  /// I have it checkbox label
  ///
  /// In ar, this message translates to:
  /// **'متوفر لدي'**
  String get iHaveThisIngredient;

  /// Ingredients on hand counter banner
  ///
  /// In ar, this message translates to:
  /// **'المتوفر لديكِ: {haveCount} من {totalCount}'**
  String ingredientsOnHandSummary(int haveCount, int totalCount);

  /// Add missing ingredients to grocery list button
  ///
  /// In ar, this message translates to:
  /// **'إضافة النواقص لقائمة التسوق'**
  String get addMissingToGrocery;

  /// Snackbar shown when missing ingredients are added
  ///
  /// In ar, this message translates to:
  /// **'تمت إضافة المكونات الناقصة إلى قائمة التسوق بنجاح!'**
  String get missingAddedToGrocerySnackbar;

  /// Start cook mode action button
  ///
  /// In ar, this message translates to:
  /// **'ابدأي الطهي'**
  String get startCooking;

  /// Save action dynamic button initial text
  ///
  /// In ar, this message translates to:
  /// **'حفظ الوصفة'**
  String get dynamicSaveAction;

  /// Save action dynamic button in-progress text
  ///
  /// In ar, this message translates to:
  /// **'جاري الحفظ...'**
  String get dynamicSavingAction;

  /// Save action dynamic button completed text
  ///
  /// In ar, this message translates to:
  /// **'تم الحفظ ✓'**
  String get dynamicSavedAction;

  /// View all saved recipes button on home screen
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get viewAllSavedRecipes;

  /// Snackbar shown when recipe is removed from saved list
  ///
  /// In ar, this message translates to:
  /// **'تمت إزالة الوصفة من المفضلة'**
  String get recipeRemovedFromSaved;

  /// Undo action label
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undo;

  /// Remove action label
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get remove;

  /// Prep and cook minutes label
  ///
  /// In ar, this message translates to:
  /// **'التحضير: {prep} د • الطهي: {cook} د'**
  String prepAndCookTime(int prep, int cook);

  /// Step number badge label
  ///
  /// In ar, this message translates to:
  /// **'خطوة {number}'**
  String stepNumberLabel(int number);

  /// Optional ingredient label
  ///
  /// In ar, this message translates to:
  /// **'(اختياري)'**
  String get optionalIngredient;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
