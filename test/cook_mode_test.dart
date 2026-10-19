import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/data/models/models.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';
import 'package:lunchbox_buddy/core/ui/timer_pill.dart';
import 'package:lunchbox_buddy/features/cook/presentation/cook_mode_screen.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/cook_celebration_view.dart';
import 'package:lunchbox_buddy/features/cook/presentation/widgets/exit_cook_dialog.dart';

Widget _buildTestApp({required Widget child}) {
  return ProviderScope(
    child: MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Directionality(textDirection: TextDirection.rtl, child: child),
    ),
  );
}

const _testTimedRecipe = Recipe(
  id: 'timed_pancake',
  title: 'بان كيك التمر اللذيذ',
  description: 'وصفة سهلة وسريعة ومغذية للأطفال.',
  prepMinutes: 5,
  cookMinutes: 12,
  servings: 2,
  tags: ['breakfast', 'quick'],
  steps: [
    'سخني المقلاة واطهي الخليط لمدة 10 دقائق على نار هادئة.',
    'ارفعي الفطائر ودعيها تبرد لمدة دقيقتين قبل التقديم.',
  ],
  ingredients: [
    RecipeIngredient(
      ingredientId: 'dates',
      quantity: 4.0,
      unit: 'piece',
      displayText: 'حبات تمر منزوع النوى',
      optional: false,
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CookModeScreen', () {
    testWidgets('renders first step with 24sp+ text and 10-minute TimerPill', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));

      await tester.pumpWidget(
        _buildTestApp(
          child: CookModeScreen(
            recipeId: _testTimedRecipe.id,
            initialRecipe: _testTimedRecipe,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check step 1 text is displayed
      expect(find.textContaining('10 دقائق على نار هادئة'), findsOneWidget);

      // Verify step typography is 24sp+
      final textFinder = find.byType(Text);
      bool found24SpOrLarger = false;
      for (final element in textFinder.evaluate()) {
        final textWidget = element.widget as Text;
        if (textWidget.data?.contains('10 دقائق على نار هادئة') == true) {
          final fontSize = textWidget.style?.fontSize ?? 0;
          if (fontSize >= 24.0) {
            found24SpOrLarger = true;
          }
        }
      }
      expect(found24SpOrLarger, isTrue);

      // Verify Step 1 counter
      expect(find.textContaining('1 من 2'), findsWidgets);

      // Verify TimerPill is detected for 10 minutes (10:00)
      expect(find.byType(TimerPill), findsOneWidget);
      expect(find.text('10:00'), findsOneWidget);
    });

    testWidgets('timers survive navigation between steps end-to-end', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));

      await tester.pumpWidget(
        _buildTestApp(
          child: CookModeScreen(
            recipeId: _testTimedRecipe.id,
            initialRecipe: _testTimedRecipe,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: verify 10:00
      expect(find.text('10:00'), findsOneWidget);

      // Start the timer on Step 1
      final startPlayIcon = find.byIcon(Icons.play_arrow_rounded);
      expect(startPlayIcon, findsOneWidget);
      await tester.tap(startPlayIcon);
      await tester.pump();

      // Advance time by 3 seconds
      await tester.pump(const Duration(seconds: 3));

      // Timer on step 1 should now display 09:57
      expect(find.text('09:57'), findsOneWidget);

      // Navigate to Step 2 using Next button
      final nextButton = find.text('الخطوة التالية');
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Verify we are on Step 2
      expect(find.textContaining('2 من 2'), findsWidgets);
      expect(find.textContaining('دقيقتين قبل التقديم'), findsOneWidget);

      // Step 2 has its own timer for 2 minutes (02:00)
      expect(find.text('02:00'), findsOneWidget);

      // Advance time another 3 seconds while on Step 2
      await tester.pump(const Duration(seconds: 3));

      // Return to Step 1 using Back button
      final prevButton = find.text('الخطوة السابقة');
      expect(prevButton, findsOneWidget);
      await tester.tap(prevButton);
      await tester.pumpAndSettle();

      // Verify we are back on Step 1
      expect(find.textContaining('1 من 2'), findsWidgets);

      // Verify Step 1 timer survived navigation and continued running in the background!
      expect(find.text('10:00'), findsNothing);
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      expect(find.textContaining('09:5'), findsOneWidget);
    });

    testWidgets('exit confirmation dialog keeps or exits cook mode', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));

      await tester.pumpWidget(
        _buildTestApp(
          child: Builder(
            builder: (context) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CookModeScreen(
                          recipeId: _testTimedRecipe.id,
                          initialRecipe: _testTimedRecipe,
                        ),
                      ),
                    );
                  },
                  child: const Text('بدء الطهي'),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap launch button to open CookModeScreen
      await tester.tap(find.text('بدء الطهي'));
      await tester.pumpAndSettle();

      expect(find.byType(CookModeScreen), findsOneWidget);

      // Tap the exit / close button (X icon)
      final closeButton = find.byIcon(Icons.close_rounded);
      expect(closeButton, findsOneWidget);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      // Verify ExitCookConfirmationDialog appears
      expect(find.byType(ExitCookConfirmationDialog), findsOneWidget);
      expect(find.text('مغادرة وضع الطهي؟'), findsOneWidget);

      // Tap "متابعة الطهي" (Continue Cooking)
      final continueButton = find.text('متابعة الطهي');
      expect(continueButton, findsOneWidget);
      await tester.tap(continueButton);
      await tester.pumpAndSettle();

      // Dialog is dismissed, still on CookModeScreen
      expect(find.byType(ExitCookConfirmationDialog), findsNothing);
      expect(find.byType(CookModeScreen), findsOneWidget);

      // Tap close button again
      await tester.tap(closeButton);
      await tester.pumpAndSettle();
      expect(find.byType(ExitCookConfirmationDialog), findsOneWidget);

      // Tap "خروج" (Confirm Exit)
      final exitButton = find.text('خروج');
      expect(exitButton, findsOneWidget);
      await tester.tap(exitButton);
      await tester.pumpAndSettle();

      // Should have popped the dialog and CookModeScreen back to launcher
      expect(find.byType(ExitCookConfirmationDialog), findsNothing);
      expect(find.byType(CookModeScreen), findsNothing);
      expect(find.text('بدء الطهي'), findsOneWidget);
    });

    testWidgets(
      'completing recipe shows celebration view with sound & animation',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(430, 932));

        await tester.pumpWidget(
          _buildTestApp(
            child: CookModeScreen(
              recipeId: _testTimedRecipe.id,
              initialRecipe: _testTimedRecipe,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Navigate to step 2
        final nextButton = find.text('الخطوة التالية');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // On final step, the button text is "إتمام الطهي"
        final completeButton = find.text('إتمام الطهي');
        expect(completeButton, findsOneWidget);

        await tester.tap(completeButton);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));

        // Celebration view is rendered
        expect(find.byType(CookCelebrationView), findsOneWidget);
        expect(find.text('تسلم الأيادي يا أمي! 🌟'), findsOneWidget);
        expect(find.text('بان كيك التمر اللذيذ'), findsOneWidget);
        expect(find.text('العودة للرئيسية'), findsOneWidget);
      },
    );
  });
}
