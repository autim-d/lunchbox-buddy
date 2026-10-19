import 'package:flutter_test/flutter_test.dart';
import 'package:lunchbox_buddy/core/utils/duration_parser.dart';

void main() {
  group('DurationParser Arabic Unit Tests', () {
    test('Parses singular minute (دقيقة / دقيقة واحدة)', () {
      final res1 = DurationParser.parseFirst('دقيقة');
      expect(res1, equals(const Duration(minutes: 1)));

      final res2 = DurationParser.parseFirst('اتركيها ترتاح لمدة دقيقة واحدة');
      expect(res2, equals(const Duration(minutes: 1)));

      final res3 = DurationParser.parseFirst('اغلي المزيج دقيقه');
      expect(res3, equals(const Duration(minutes: 1)));
    });

    test('Parses dual minutes (دقيقتين / دقيقتان)', () {
      final res1 = DurationParser.parseFirst('دقيقتين');
      expect(res1, equals(const Duration(minutes: 2)));

      final res2 = DurationParser.parseFirst(
        'قلبي المكونات على نار هادئة لمدة دقيقتان',
      );
      expect(res2, equals(const Duration(minutes: 2)));

      final res3 = DurationParser.parseFirst('حمري التوست دقيقتين حتى يقرمش');
      expect(res3, equals(const Duration(minutes: 2)));
    });

    test(
      'Parses plural and numeric minutes (10 دقائق / 5 دقائق / ١٠ دقائق)',
      () {
        final res1 = DurationParser.parseFirst('اخبزي 10 دقائق');
        expect(res1, equals(const Duration(minutes: 10)));

        final res2 = DurationParser.parseFirst('10 دقائق');
        expect(res2, equals(const Duration(minutes: 10)));

        final res3 = DurationParser.parseFirst(
          'دعيها تبرد 5 دقائق قبل التقديم',
        );
        expect(res3, equals(const Duration(minutes: 5)));

        // Arabic-Indic digits: ١٠ دقائق
        final resArabicIndic = DurationParser.parseFirst(
          'ضعيها في المقلاة لمدة ١٠ دقائق',
        );
        expect(resArabicIndic, equals(const Duration(minutes: 10)));

        final resRange = DurationParser.parseFirst(
          'اطبخي على نار هادئة من 10 إلى 15 دقيقة',
        );
        expect(resRange, equals(const Duration(minutes: 10)));
      },
    );

    test('Parses hours (ساعة / ساعتين / نصف ساعة / ساعة ونصف)', () {
      final resHour = DurationParser.parseFirst('ساعة');
      expect(resHour, equals(const Duration(hours: 1)));

      final resHourText = DurationParser.parseFirst(
        'اتركي العجينة لتتخمر لمدة ساعة واحدة',
      );
      expect(resHourText, equals(const Duration(hours: 1)));

      final resHalfHour = DurationParser.parseFirst('انقعي الشوفان نصف ساعة');
      expect(resHalfHour, equals(const Duration(minutes: 30)));

      final resHourAndHalf = DurationParser.parseFirst('ساعة ونصف في الثلاجة');
      expect(resHourAndHalf, equals(const Duration(minutes: 90)));

      final resTwoHours = DurationParser.parseFirst('ساعتين');
      expect(resTwoHours, equals(const Duration(hours: 2)));
    });

    test('Parses seconds (30 ثانية / نصف دقيقة)', () {
      final resSec = DurationParser.parseFirst('اخفقي البيض لمدة 30 ثانية');
      expect(resSec, equals(const Duration(seconds: 30)));

      final resHalfMin = DurationParser.parseFirst(
        'سخني في الميكروويف نصف دقيقة',
      );
      expect(resHalfMin, equals(const Duration(seconds: 30)));
    });

    test('Returns null when no duration is mentioned in text', () {
      expect(DurationParser.parseFirst('اخلطي الموز مع الشوفان جيدا'), isNull);
      expect(DurationParser.parseFirst(''), isNull);
      expect(
        DurationParser.parseFirst('قدميها دافئة لأطفالك مع العسل'),
        isNull,
      );
    });

    test('formatDigital formats hours, minutes, and seconds properly', () {
      expect(
        DurationParser.formatDigital(const Duration(minutes: 10)),
        equals('10:00'),
      );
      expect(
        DurationParser.formatDigital(const Duration(minutes: 2, seconds: 5)),
        equals('02:05'),
      );
      expect(
        DurationParser.formatDigital(const Duration(seconds: 45)),
        equals('00:45'),
      );
      expect(
        DurationParser.formatDigital(const Duration(hours: 1, minutes: 15)),
        equals('01:15:00'),
      );
      expect(
        DurationParser.formatDigital(const Duration(seconds: -5)),
        equals('00:00'),
      );
    });
  });
}
