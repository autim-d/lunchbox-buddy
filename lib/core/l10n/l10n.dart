import 'package:flutter/widgets.dart';
import 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';

export 'package:lunchbox_buddy/core/l10n/generated/app_localizations.dart';

/// Extension on [BuildContext] for clean access to [AppLocalizations].
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
