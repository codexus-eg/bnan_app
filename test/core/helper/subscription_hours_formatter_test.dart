import 'package:bnan_app/core/helper/subscription_hours_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SubscriptionHoursFormatter', () {
    test('formats fractional hours matching portal screenshot in Arabic', () {
      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          0.068,
          isArabic: true,
          isRemaining: false,
        ),
        '4 دقيقة',
      );

      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          19.932,
          isArabic: true,
          isRemaining: true,
        ),
        '19 ساعة و56 دقيقة',
      );
    });

    test('formats fractional hours matching portal in English', () {
      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          0.068,
          isArabic: false,
          isRemaining: false,
        ),
        '4 min',
      );

      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          19.932,
          isArabic: false,
          isRemaining: true,
        ),
        '19 hr 56 min',
      );
    });

    test('formats whole hours correctly', () {
      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          20,
          isArabic: true,
          isRemaining: true,
        ),
        '20 ساعة',
      );

      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          2,
          isArabic: true,
          isRemaining: false,
        ),
        '2 ساعة',
      );
    });

    test('formats zero hours correctly for used and remaining', () {
      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          0,
          isArabic: true,
          isRemaining: false,
        ),
        '0 دقيقة',
      );

      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          0,
          isArabic: true,
          isRemaining: true,
        ),
        '0 ساعة',
      );
    });

    test('formats half hours and sub-hour durations correctly', () {
      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          0.5,
          isArabic: true,
          isRemaining: false,
        ),
        '30 دقيقة',
      );

      expect(
        SubscriptionHoursFormatter.formatHoursWithLocale(
          1.5,
          isArabic: true,
          isRemaining: true,
        ),
        '1 ساعة و30 دقيقة',
      );
    });
  });
}
