import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/ai/ai_client.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/core/ui/app_button.dart';
import 'package:lunchbox_buddy/features/debug/presentation/ai_debug_screen.dart';

class _CustomConfigNotifier extends AppConfigNotifier {
  _CustomConfigNotifier(this._config);
  final AppConfig _config;

  @override
  AppConfig build() => _config;
}

void main() {
  Widget buildTestableWidget({List<dynamic> overrides = const []}) {
    return ProviderScope(
      overrides: overrides.cast(),
      child: const MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('ar')],
        locale: Locale('ar'),
        home: AiDebugScreen(),
      ),
    );
  }

  testWidgets('AiDebugScreen displays environment card and button', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    const testConfig = AppConfig(
      geminiModel: 'gemini-2.5-flash',
      requestTimeoutSeconds: 12,
      maxRetries: 2,
    );

    await tester.pumpWidget(
      buildTestableWidget(
        overrides: [
          appConfigProvider.overrideWith(() => _CustomConfigNotifier(testConfig)),
        ],
      ),
    );

    expect(find.text('فاحص Firebase AI Logic (Debug)'), findsOneWidget);
    expect(find.text('بيئة التشغيل والاتصال'), findsOneWidget);
    expect(find.text('gemini-2.5-flash'), findsOneWidget);
    expect(find.text('12 ثوانٍ'), findsOneWidget);
    expect(find.text('2 محاولة'), findsOneWidget);
    expect(find.text('اختبار إرسال استعلام مهيكل (Ping AI)'), findsOneWidget);
  });

  testWidgets('AiDebugScreen executes ping and renders success card', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    const testConfig = AppConfig();
    final mockAiClient = AiClient(
      config: testConfig,
      invoker: ({
        required String modelName,
        required GenerationConfig generationConfig,
        Content? systemInstruction,
        required Iterable<Content> prompt,
      }) async {
        return '''
        {
          "snackName": "شرائح تفاح بزبدة الفول السوداني",
          "prepTimeMinutes": 3,
          "ingredients": ["تفاح", "زبدة فول سوداني"],
          "tip": "قطعي التفاح لشرائح رفيعة لتسهيل القضم"
        }
        ''';
      },
    );

    await tester.pumpWidget(
      buildTestableWidget(
        overrides: [
          aiClientProvider.overrideWithValue(mockAiClient),
        ],
      ),
    );

    final buttonFinder = find.byType(AppButton);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    // Verify success card elements
    expect(find.text('استجابة مهيكلة ناجحة (Schema Validated)'), findsOneWidget);
    expect(find.text('شرائح تفاح بزبدة الفول السوداني'), findsOneWidget);
    expect(find.text('وقت التحضير: 3 دقائق'), findsOneWidget);
    expect(find.text('تفاح'), findsOneWidget);
    expect(find.text('زبدة فول سوداني'), findsOneWidget);
    expect(find.text('قطعي التفاح لشرائح رفيعة لتسهيل القضم'), findsOneWidget);
  });

  testWidgets('AiDebugScreen displays clean Failure card on network error without crashing', (tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    const testConfig = AppConfig(maxRetries: 0);
    final mockAiClient = AiClient(
      config: testConfig,
      invoker: ({
        required String modelName,
        required GenerationConfig generationConfig,
        Content? systemInstruction,
        required Iterable<Content> prompt,
      }) async {
        throw const SocketException('No route to host');
      },
    );

    await tester.pumpWidget(
      buildTestableWidget(
        overrides: [
          aiClientProvider.overrideWithValue(mockAiClient),
        ],
      ),
    );

    final buttonFinder = find.byType(AppButton);
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();

    // Verify failure card
    expect(find.textContaining('فشل الاستعلام النظيف (NetworkFailure)'), findsOneWidget);
    expect(find.textContaining('Network connection unavailable'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
  });
}
