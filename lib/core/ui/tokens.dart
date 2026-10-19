import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for Lunchbox Buddy (لانش بوكس بادي)
/// Follows skill section 8: warm, tactile, playful, trustworthy kitchen aesthetic.
abstract final class AppTokens {
  static const colors = AppColors();
  static const spacing = AppSpacing();
  static const radii = AppRadii();
  static const touchTargets = AppTouchTargets();
  static const durations = AppDurations();
  static const curves = AppCurves();
  static const typography = AppTypography();
}

/// Palette tokens
class AppColors {
  const AppColors();

  // Backgrounds: warm off-white, paper & ceramic feel
  final Color background = const Color(0xFFFAF7F2);
  final Color surface = const Color(0xFFFFFFFF);
  final Color surfaceSubtle = const Color(0xFFF5EFEB);

  // Text: deep warm brown and warm charcoal (never pure black)
  final Color textPrimary = const Color(0xFF2C2420);
  final Color textSecondary = const Color(0xFF6B5E55);
  final Color textMuted = const Color(0xFF96887D);
  final Color textInverse = const Color(0xFFFFFFFF);

  // Accent: confident tomato red/vermilion
  final Color accent = const Color(0xFFD94A2B);
  final Color accentHover = const Color(0xFFBF3A1D);
  final Color accentContainer = const Color(0xFFFDEEEA);
  final Color onAccent = const Color(0xFFFFFFFF);

  // Secondary: fresh herb green
  final Color secondary = const Color(0xFF2D6A4F);
  final Color secondaryHover = const Color(0xFF22523D);
  final Color secondaryContainer = const Color(0xFFE8F3ED);
  final Color onSecondary = const Color(0xFFFFFFFF);

  // Soft semantic status colors
  final Color success = const Color(0xFF2E7D32);
  final Color successContainer = const Color(0xFFE8F5E9);
  final Color warning = const Color(0xFFD97706);
  final Color warningContainer = const Color(0xFFFEF3C7);
  final Color error = const Color(0xFFDC2626);
  final Color errorContainer = const Color(0xFFFEE2E2);

  // Borders, dividers & tactile shadows
  final Color border = const Color(0xFFE6DFD5);
  final Color borderSubtle = const Color(0xFFF0EBE4);
  final Color buttonShadow = const Color(0x332C2420);
}

/// Spacing scale: 4 / 8 / 12 / 16 / 24 / 32
class AppSpacing {
  const AppSpacing();

  final double xs = 4.0;
  final double sm = 8.0;
  final double md = 12.0;
  final double lg = 16.0;
  final double xl = 24.0;
  final double xxl = 32.0;
  final double xxxl = 48.0;
}

/// Radii scale: 16-24 for cards, fully round for chips
class AppRadii {
  const AppRadii();

  final double sm = 8.0;
  final double md = 12.0;
  final double card = 20.0;
  final double cardLg = 24.0;
  final double full = 999.0;
}

/// Touch target sizes: at least 48x48, primary actions 56
class AppTouchTargets {
  const AppTouchTargets();

  final double min = 48.0;
  final double primaryAction = 56.0;
}

/// Motion durations: 150-300 ms
class AppDurations {
  const AppDurations();

  final Duration quick = const Duration(milliseconds: 150);
  final Duration standard = const Duration(milliseconds: 250);
  final Duration relaxed = const Duration(milliseconds: 300);
}

/// Motion curves
class AppCurves {
  const AppCurves();

  final Curve easeOut = Curves.easeOut;
  final Curve easeInOut = Curves.easeInOut;
}

/// Typography tokens using Cairo font for Arabic
class AppTypography {
  const AppTypography();

  TextStyle get displayLarge => GoogleFonts.cairo(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppTokens.colors.textPrimary,
    height: 1.25,
  );

  TextStyle get displayMedium => GoogleFonts.cairo(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppTokens.colors.textPrimary,
    height: 1.25,
  );

  // Cook Mode step text & large headers (24+)
  TextStyle get cookModeStep => GoogleFonts.cairo(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppTokens.colors.textPrimary,
    height: 1.35,
  );

  TextStyle get titleLarge => GoogleFonts.cairo(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: AppTokens.colors.textPrimary,
    height: 1.3,
  );

  TextStyle get titleMedium => GoogleFonts.cairo(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppTokens.colors.textPrimary,
    height: 1.3,
  );

  TextStyle get titleSmall => GoogleFonts.cairo(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppTokens.colors.textPrimary,
    height: 1.3,
  );

  // Minimum body 16
  TextStyle get bodyLarge => GoogleFonts.cairo(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    color: AppTokens.colors.textPrimary,
    height: 1.5,
  );

  TextStyle get bodyMedium => GoogleFonts.cairo(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppTokens.colors.textPrimary,
    height: 1.5,
  );

  TextStyle get bodySmall => GoogleFonts.cairo(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppTokens.colors.textSecondary,
    height: 1.4,
  );

  TextStyle get labelLarge => GoogleFonts.cairo(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppTokens.colors.textPrimary,
    height: 1.2,
  );

  TextStyle get labelMedium => GoogleFonts.cairo(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppTokens.colors.textSecondary,
    height: 1.2,
  );
}

/// Helper for application theme building
abstract final class AppTheme {
  static ThemeData get lightTheme {
    const colors = AppTokens.colors;
    const typography = AppTokens.typography;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.light(
        surface: colors.surface,
        primary: colors.accent,
        onPrimary: colors.onAccent,
        primaryContainer: colors.accentContainer,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        secondaryContainer: colors.secondaryContainer,
        error: colors.error,
        onError: colors.textInverse,
      ),
      textTheme: TextTheme(
        displayLarge: typography.displayLarge,
        displayMedium: typography.displayMedium,
        headlineMedium: typography.cookModeStep,
        titleLarge: typography.titleLarge,
        titleMedium: typography.titleMedium,
        titleSmall: typography.titleSmall,
        bodyLarge: typography.bodyLarge,
        bodyMedium: typography.bodyMedium,
        bodySmall: typography.bodySmall,
        labelLarge: typography.labelLarge,
        labelMedium: typography.labelMedium,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: typography.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radii.card),
          side: BorderSide(color: colors.borderSubtle),
        ),
      ),
    );
  }
}
