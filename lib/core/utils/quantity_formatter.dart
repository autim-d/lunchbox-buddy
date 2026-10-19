/// Pure Dart utility to scale and format ingredient quantities into clean,
/// readable kitchen fractions (e.g., 1/4, 1/2, 1 1/2) using Western digits.
class QuantityFormatter {
  const QuantityFormatter._();

  /// Scales [baseQuantity] from [baseServings] to [targetServings].
  static double? scale(
    double? baseQuantity, {
    int baseServings = 1,
    int targetServings = 1,
  }) {
    if (baseQuantity == null) return null;
    if (baseServings <= 0) baseServings = 1;
    if (targetServings <= 0) targetServings = 1;
    return baseQuantity * (targetServings / baseServings);
  }

  /// Formats [baseQuantity] scaled to [targetServings] into a vulgar fraction string.
  /// Examples:
  /// - 0.25 -> "1/4"
  /// - 0.5  -> "1/2"
  /// - 0.75 -> "3/4"
  /// - 1.5  -> "1 1/2"
  /// - 2.0  -> "2"
  static String format(
    double? baseQuantity, {
    int baseServings = 1,
    int targetServings = 1,
  }) {
    final scaled = scale(
      baseQuantity,
      baseServings: baseServings,
      targetServings: targetServings,
    );
    if (scaled == null) return '';

    return formatValue(scaled);
  }

  /// Formats a single double value into clean whole, fractional, or decimal representation.
  static String formatValue(double value) {
    if (value <= 0) return '0';

    final whole = value.floor();
    final remainder = value - whole;

    // Check for whole number
    if (remainder < 0.03 || remainder > 0.97) {
      final rounded = value.round();
      return rounded.toString();
    }

    String? fractionStr;
    const eps = 0.04;

    if ((remainder - 0.25).abs() < eps) {
      fractionStr = '1/4';
    } else if ((remainder - 0.5).abs() < eps) {
      fractionStr = '1/2';
    } else if ((remainder - 0.75).abs() < eps) {
      fractionStr = '3/4';
    } else if ((remainder - 0.333).abs() < eps) {
      fractionStr = '1/3';
    } else if ((remainder - 0.667).abs() < eps) {
      fractionStr = '2/3';
    } else if ((remainder - 0.125).abs() < eps) {
      fractionStr = '1/8';
    }

    if (fractionStr != null) {
      if (whole == 0) {
        return fractionStr;
      } else {
        return '$whole $fractionStr';
      }
    }

    // Default to clean 1 decimal place string if not a standard kitchen fraction
    final formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      return formatted.substring(0, formatted.length - 2);
    }
    return formatted;
  }
}
