/// Parsed duration entity representing a detected duration within recipe step text.
class ParsedDuration {
  const ParsedDuration({
    required this.duration,
    required this.matchedText,
    required this.label,
  });

  final Duration duration;
  final String matchedText;
  final String label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParsedDuration &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          label == other.label;

  @override
  int get hashCode => duration.hashCode ^ label.hashCode;

  @override
  String toString() => 'ParsedDuration($duration, label: "$label")';
}

/// Utility for detecting and parsing cooking durations in Arabic and English step instructions.
class DurationParser {
  const DurationParser._();

  static String _normalizeArabicDigits(String text) {
    const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = text;
    for (var i = 0; i < arabicIndic.length; i++) {
      result = result.replaceAll(arabicIndic[i], '$i');
    }
    return result;
  }

  /// Extracts all detected durations from [text].
  static List<ParsedDuration> parseAll(String text) {
    if (text.trim().isEmpty) return const [];

    final normalized = _normalizeArabicDigits(text);
    final results = <ParsedDuration>[];
    final matchedSpans = <(int, int)>[];

    bool overlaps(int start, int end) {
      for (final span in matchedSpans) {
        if (!(end <= span.$1 || start >= span.$2)) {
          return true;
        }
      }
      return false;
    }

    void addMatch(int start, int end, Duration duration, String label) {
      if (!overlaps(start, end)) {
        matchedSpans.add((start, end));
        final originalMatched = text.substring(start, end);
        results.add(
          ParsedDuration(
            duration: duration,
            matchedText: originalMatched,
            label: label,
          ),
        );
      }
    }

    // 1. Multi-word special phrases (hour and a half, half an hour, quarter hour, etc.)
    const bStart = r'(?:^|[^\u0600-\u06FF0-9a-zA-Z])';
    const bEnd = r'(?=$|[^\u0600-\u06FF0-9a-zA-Z])';

    final specialPhrases = <(RegExp, Duration, String)>[
      (
        RegExp(
          '$bStart(?:ساعة\\s+و\\s*نصف|ساعة\\s+ونصف)$bEnd',
          caseSensitive: false,
        ),
        const Duration(minutes: 90),
        'ساعة ونصف',
      ),
      (
        RegExp(
          '$bStart(?:ساعتين\\s+و\\s*نصف|ساعتين\\s+ونصف)$bEnd',
          caseSensitive: false,
        ),
        const Duration(minutes: 150),
        'ساعتان ونصف',
      ),
      (
        RegExp('$bStart(?:نصف\\s+ساعة|نصف\\s+ساعه)$bEnd', caseSensitive: false),
        const Duration(minutes: 30),
        'نصف ساعة',
      ),
      (
        RegExp('$bStart(?:ثلث\\s+ساعة|ثلث\\s+ساعه)$bEnd', caseSensitive: false),
        const Duration(minutes: 20),
        'ثلث ساعة',
      ),
      (
        RegExp('$bStart(?:ربع\\s+ساعة|ربع\\s+ساعه)$bEnd', caseSensitive: false),
        const Duration(minutes: 15),
        'ربع ساعة',
      ),
      (
        RegExp(
          '$bStart(?:نصف\\s+دقيقة|نصف\\s+دقيقه)$bEnd',
          caseSensitive: false,
        ),
        const Duration(seconds: 30),
        'نصف دقيقة',
      ),
    ];

    for (final (regex, dur, label) in specialPhrases) {
      for (final match in regex.allMatches(normalized)) {
        addMatch(match.start, match.end, dur, label);
      }
    }

    // 2. Dual words: دقيقتين, دقيقتان, ساعتين, ساعتان, ثانيتين, ثانيتان
    final dualPatterns = <(RegExp, Duration, String)>[
      (
        RegExp('$bStart(?:دقيقتين|دقيقتان)$bEnd', caseSensitive: false),
        const Duration(minutes: 2),
        'دقيقتان',
      ),
      (
        RegExp('$bStart(?:ساعتين|ساعتان)$bEnd', caseSensitive: false),
        const Duration(hours: 2),
        'ساعتان',
      ),
      (
        RegExp('$bStart(?:ثانيتين|ثانيتان)$bEnd', caseSensitive: false),
        const Duration(seconds: 2),
        'ثانيتان',
      ),
    ];

    for (final (regex, dur, label) in dualPatterns) {
      for (final match in regex.allMatches(normalized)) {
        addMatch(match.start, match.end, dur, label);
      }
    }

    // 3. Numeric matches: (e.g. 10 دقائق, 5 دقائق, 10 إلى 15 دقيقة, 1.5 ساعة, 30 ثانية, 10 mins)
    // Matches: <number> (optional to <number>) <unit>
    final numericRegex = RegExp(
      '(\\d+(?:\\.\\d+)?)\\s*(?:-|إلى|الى)?\\s*(?:\\d+(?:\\.\\d+)?)?\\s*'
      '(دقيقة|دقيقه|دقائق|دقايق|ساعة|ساعه|ساعات|ثانية|ثانيه|ثواني|ثوان|min|mins|minute|minutes|hour|hours|hr|hrs|sec|secs|second|seconds)$bEnd',
      caseSensitive: false,
    );

    for (final match in numericRegex.allMatches(normalized)) {
      final numberStr = match.group(1);
      final unitStr = match.group(2)?.toLowerCase();

      if (numberStr != null && unitStr != null) {
        final number = double.tryParse(numberStr);
        if (number != null && number > 0) {
          Duration duration;
          String label;

          if (unitStr.startsWith('د') || unitStr.startsWith('min')) {
            final mins = number.round();
            duration = Duration(minutes: mins);
            label = '$mins ${_pluralizeMinutes(mins)}';
          } else if (unitStr.startsWith('س') ||
              unitStr.startsWith('hour') ||
              unitStr.startsWith('hr')) {
            final mins = (number * 60).round();
            duration = Duration(minutes: mins);
            label = number == 1
                ? 'ساعة واحدة'
                : (number == 2 ? 'ساعتان' : '$number ساعات');
          } else if (unitStr.startsWith('ث') || unitStr.startsWith('sec')) {
            final secs = number.round();
            duration = Duration(seconds: secs);
            label = '$secs ${_pluralizeSeconds(secs)}';
          } else {
            continue;
          }

          addMatch(match.start, match.end, duration, label);
        }
      }
    }

    // 4. Singular words: دقيقة, دقيقة واحدة, ساعة, ساعة واحدة, ثانية واحدة
    final singularPatterns = <(RegExp, Duration, String)>[
      (
        RegExp(
          '$bStart(?:دقيقة\\s+واحدة|دقيقه\\s+واحده|دقيقة|دقيقه)$bEnd',
          caseSensitive: false,
        ),
        const Duration(minutes: 1),
        'دقيقة واحدة',
      ),
      (
        RegExp(
          '$bStart(?:ساعة\\s+واحدة|ساعه\\s+واحده|ساعة|ساعه)$bEnd',
          caseSensitive: false,
        ),
        const Duration(hours: 1),
        'ساعة واحدة',
      ),
      (
        RegExp(
          '$bStart(?:ثانية\\s+واحدة|ثانيه\\s+واحده|ثانية|ثانيه)$bEnd',
          caseSensitive: false,
        ),
        const Duration(seconds: 1),
        'ثانية واحدة',
      ),
    ];

    for (final (regex, dur, label) in singularPatterns) {
      for (final match in regex.allMatches(normalized)) {
        addMatch(match.start, match.end, dur, label);
      }
    }

    return results;
  }

  /// Extracts the first duration found in [text], or null if none.
  static Duration? parseFirst(String text) {
    final all = parseAll(text);
    return all.isNotEmpty ? all.first.duration : null;
  }

  /// Formats [duration] as digital MM:SS or HH:MM:SS (Western digits).
  static String formatDigital(Duration duration) {
    if (duration.isNegative) return '00:00';

    final totalSeconds = duration.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    return '$mStr:$sStr';
  }

  static String _pluralizeMinutes(int mins) {
    if (mins == 1) return 'دقيقة';
    if (mins == 2) return 'دقيقتان';
    if (mins >= 3 && mins <= 10) return 'دقائق';
    return 'دقيقة';
  }

  static String _pluralizeSeconds(int secs) {
    if (secs == 1) return 'ثانية';
    if (secs == 2) return 'ثانيتان';
    if (secs >= 3 && secs <= 10) return 'ثوانٍ';
    return 'ثانية';
  }
}
