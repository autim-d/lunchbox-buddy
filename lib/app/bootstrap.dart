import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lunchbox_buddy/app/app.dart';
import 'package:lunchbox_buddy/core/config/app_config.dart';
import 'package:lunchbox_buddy/firebase_options_dev.dart';

/// Application bootstrap orchestrating Firebase initialization, App Check,
/// Anonymous Authentication, Crashlytics, and Remote Config.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Core Firebase Initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    debugPrint('Firebase.initializeApp warning/error: $e\n$stack');
  }

  // Set up Crashlytics global error reporting on supported mobile platforms
  final isCrashlyticsSupported = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  if (isCrashlyticsSupported) {
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  final container = ProviderContainer();

  // 2. Launch UI immediately for fast cold start (< 2s)
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LunchboxBuddyApp(),
    ),
  );

  // 3. Defer secondary services (App Check, Anonymous Auth, Remote Config) until after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_initPostFrameServices(container));
  });
}

/// Initializes non-critical background services after the first visual frame renders
Future<void> _initPostFrameServices(ProviderContainer container) async {
  // A. App Check activation (debug provider in debug builds)
  try {
    await FirebaseAppCheck.instance.activate(
      providerAndroid:
          kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
      providerApple:
          kDebugMode ? const AppleDebugProvider() : const AppleDeviceCheckProvider(),
    );
    debugPrint('FirebaseAppCheck successfully activated (debugMode: $kDebugMode)');
  } catch (e) {
    debugPrint('FirebaseAppCheck activation skipped or failed: $e');
  }

  // B. Anonymous Auth (ensures signed-in context without user-facing account wall)
  try {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      final credential = await auth.signInAnonymously();
      debugPrint('FirebaseAuth anonymous user established: ${credential.user?.uid}');
    } else {
      debugPrint('FirebaseAuth existing user active: ${auth.currentUser?.uid}');
    }
  } catch (e) {
    debugPrint('FirebaseAuth anonymous sign-in error: $e');
  }

  // C. Remote Config synchronization
  try {
    final config = await AppConfigService.initRemoteConfig();
    container.read(appConfigProvider.notifier).updateConfig(config);
    debugPrint('AppConfig loaded from Remote Config: $config');
  } catch (e) {
    debugPrint('Remote Config sync skipped or failed: $e');
  }
}
