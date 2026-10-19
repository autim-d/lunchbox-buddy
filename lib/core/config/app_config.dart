import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application configuration containing AI model identifiers, timeouts, and feature flags.
/// Driven by Firebase Remote Config with safe local offline fallbacks.
@immutable
class AppConfig {
  const AppConfig({
    this.geminiModel = defaultGeminiModel,
    this.requestTimeoutSeconds = defaultTimeoutSeconds,
    this.maxRetries = defaultMaxRetries,
    this.enableAiSuggestions = defaultEnableAiSuggestions,
    this.enableFridgeScan = defaultEnableFridgeScan,
    this.enableVoiceInput = defaultEnableVoiceInput,
    this.maintenanceMode = defaultMaintenanceMode,
  });

  // Safe local default constants
  static const String defaultGeminiModel = 'gemini-2.5-flash';
  static const int defaultTimeoutSeconds = 15;
  static const int defaultMaxRetries = 1;
  static const bool defaultEnableAiSuggestions = true;
  static const bool defaultEnableFridgeScan = false;
  static const bool defaultEnableVoiceInput = false;
  static const bool defaultMaintenanceMode = false;

  // Remote config parameter keys
  static const String keyGeminiModel = 'gemini_model_name';
  static const String keyTimeoutSeconds = 'request_timeout_seconds';
  static const String keyMaxRetries = 'max_retries';
  static const String keyEnableAiSuggestions = 'enable_ai_suggestions';
  static const String keyEnableFridgeScan = 'enable_fridge_scan';
  static const String keyEnableVoiceInput = 'enable_voice_input';
  static const String keyMaintenanceMode = 'maintenance_mode';

  final String geminiModel;
  final int requestTimeoutSeconds;
  final int maxRetries;
  final bool enableAiSuggestions;
  final bool enableFridgeScan;
  final bool enableVoiceInput;
  final bool maintenanceMode;

  AppConfig copyWith({
    String? geminiModel,
    int? requestTimeoutSeconds,
    int? maxRetries,
    bool? enableAiSuggestions,
    bool? enableFridgeScan,
    bool? enableVoiceInput,
    bool? maintenanceMode,
  }) {
    return AppConfig(
      geminiModel: geminiModel ?? this.geminiModel,
      requestTimeoutSeconds:
          requestTimeoutSeconds ?? this.requestTimeoutSeconds,
      maxRetries: maxRetries ?? this.maxRetries,
      enableAiSuggestions: enableAiSuggestions ?? this.enableAiSuggestions,
      enableFridgeScan: enableFridgeScan ?? this.enableFridgeScan,
      enableVoiceInput: enableVoiceInput ?? this.enableVoiceInput,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }

  /// Construct AppConfig from Firebase Remote Config values
  factory AppConfig.fromRemoteConfig(FirebaseRemoteConfig remoteConfig) {
    final modelVal = remoteConfig.getString(keyGeminiModel);
    final timeoutVal = remoteConfig.getInt(keyTimeoutSeconds);
    final retriesVal = remoteConfig.getInt(keyMaxRetries);
    final aiVal = remoteConfig.getBool(keyEnableAiSuggestions);
    final fridgeVal = remoteConfig.getBool(keyEnableFridgeScan);
    final voiceVal = remoteConfig.getBool(keyEnableVoiceInput);
    final maintVal = remoteConfig.getBool(keyMaintenanceMode);

    return AppConfig(
      geminiModel: modelVal.isNotEmpty ? modelVal : defaultGeminiModel,
      requestTimeoutSeconds: timeoutVal > 0
          ? timeoutVal
          : defaultTimeoutSeconds,
      maxRetries: retriesVal >= 0 ? retriesVal : defaultMaxRetries,
      enableAiSuggestions: aiVal,
      enableFridgeScan: fridgeVal,
      enableVoiceInput: voiceVal,
      maintenanceMode: maintVal,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConfig &&
          runtimeType == other.runtimeType &&
          geminiModel == other.geminiModel &&
          requestTimeoutSeconds == other.requestTimeoutSeconds &&
          maxRetries == other.maxRetries &&
          enableAiSuggestions == other.enableAiSuggestions &&
          enableFridgeScan == other.enableFridgeScan &&
          enableVoiceInput == other.enableVoiceInput &&
          maintenanceMode == other.maintenanceMode);

  @override
  int get hashCode => Object.hash(
    geminiModel,
    requestTimeoutSeconds,
    maxRetries,
    enableAiSuggestions,
    enableFridgeScan,
    enableVoiceInput,
    maintenanceMode,
  );

  @override
  String toString() =>
      'AppConfig(geminiModel: $geminiModel, timeout: ${requestTimeoutSeconds}s, maxRetries: $maxRetries, aiEnabled: $enableAiSuggestions)';
}

/// Service managing Remote Config synchronization
class AppConfigService {
  AppConfigService._();

  /// Initializes Remote Config with safe local defaults and attempts to fetch & activate.
  static Future<AppConfig> initRemoteConfig({
    FirebaseRemoteConfig? customInstance,
  }) async {
    try {
      final remoteConfig = customInstance ?? FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );

      // Seed local safe defaults into Remote Config
      await remoteConfig.setDefaults({
        AppConfig.keyGeminiModel: AppConfig.defaultGeminiModel,
        AppConfig.keyTimeoutSeconds: AppConfig.defaultTimeoutSeconds,
        AppConfig.keyMaxRetries: AppConfig.defaultMaxRetries,
        AppConfig.keyEnableAiSuggestions: AppConfig.defaultEnableAiSuggestions,
        AppConfig.keyEnableFridgeScan: AppConfig.defaultEnableFridgeScan,
        AppConfig.keyEnableVoiceInput: AppConfig.defaultEnableVoiceInput,
        AppConfig.keyMaintenanceMode: AppConfig.defaultMaintenanceMode,
      });

      // Fetch and activate latest remote parameters
      await remoteConfig.fetchAndActivate();

      return AppConfig.fromRemoteConfig(remoteConfig);
    } catch (e) {
      debugPrint('AppConfigService remote fetch skipped or offline: $e');
      return const AppConfig();
    }
  }
}

/// Riverpod provider delivering the current AppConfig
final appConfigProvider = NotifierProvider<AppConfigNotifier, AppConfig>(
  AppConfigNotifier.new,
);

class AppConfigNotifier extends Notifier<AppConfig> {
  @override
  AppConfig build() => const AppConfig();

  void updateConfig(AppConfig config) {
    state = config;
  }
}
