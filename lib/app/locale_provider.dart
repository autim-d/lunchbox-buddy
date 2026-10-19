import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier that manages active app locale.
///
/// Default locale is Saudi-friendly Arabic (ar) regardless of host device language.
class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('ar');
  }

  void setLocale(Locale newLocale) {
    state = newLocale;
  }

  void toggleLocale() {
    state = state.languageCode == 'ar'
        ? const Locale('en')
        : const Locale('ar');
  }
}

/// Provider for app-wide locale management
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(
  AppLocaleNotifier.new,
);
