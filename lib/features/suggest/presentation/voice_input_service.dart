import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Service managing speech-to-text recording with Arabic (Saudi) locale preference.
class VoiceInputService {
  VoiceInputService({SpeechToText? speech})
    : _speech = speech ?? SpeechToText();

  final SpeechToText _speech;
  bool _isInitialized = false;
  String? _preferredLocaleId;

  bool get isListening => _speech.isListening;
  bool get isAvailable => _speech.isAvailable;

  /// Initializes the speech recognizer and queries available locales
  Future<bool> initialize() async {
    if (_isInitialized) return _speech.isAvailable;

    try {
      final available = await _speech.initialize(
        onError: (SpeechRecognitionError error) {
          debugPrint(
            'SpeechToText error: ${error.errorMsg} (permanent: ${error.permanent})',
          );
        },
        onStatus: (String status) {
          debugPrint('SpeechToText status: $status');
        },
      );

      _isInitialized = true;

      if (available) {
        final locales = await _speech.locales();
        // Priority 1: Saudi Arabic (ar_SA)
        // Priority 2: Any Arabic dialect (ar_*)
        // Priority 3: System default
        final saudi = locales
            .where(
              (l) => l.localeId.toLowerCase().replaceAll('-', '_') == 'ar_sa',
            )
            .firstOrNull;
        final anyArabic = locales
            .where((l) => l.localeId.toLowerCase().startsWith('ar'))
            .firstOrNull;

        _preferredLocaleId = saudi?.localeId ?? anyArabic?.localeId ?? 'ar_SA';
      }

      return available;
    } catch (e) {
      debugPrint('SpeechToText failed to initialize: $e');
      return false;
    }
  }

  /// Starts listening for spoken Arabic words
  Future<bool> startListening({
    required ValueChanged<String> onResult,
    required VoidCallback onListeningComplete,
  }) async {
    final available = await initialize();
    if (!available) return false;

    await HapticFeedback.mediumImpact();

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
          if (result.finalResult) {
            onListeningComplete();
          }
        },
        listenOptions: SpeechListenOptions(
          localeId: _preferredLocaleId ?? 'ar_SA',
          listenMode: ListenMode.dictation,
          cancelOnError: true,
          partialResults: true,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('SpeechToText listen failed: $e');
      return false;
    }
  }

  /// Stops listening and triggers light haptic tap
  Future<void> stopListening() async {
    try {
      await HapticFeedback.lightImpact();
      await _speech.stop();
    } catch (e) {
      debugPrint('SpeechToText stop failed: $e');
    }
  }
}

/// Riverpod provider for VoiceInputService
final voiceInputServiceProvider = Provider<VoiceInputService>((ref) {
  return VoiceInputService();
});
