import 'package:bnan_app/core/utils/schedule_time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScheduleTimeUtils - weekday & date matching', () {
    final saturday = DateTime(2026, 10, 24, 10, 0); // Saturday
    final tuesday = DateTime(2026, 10, 27, 10, 0); // Tuesday

    test('matches English weekday names case-insensitively', () {
      expect(ScheduleTimeUtils.isDayOrDateMatch('saturday', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('Saturday', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('SATURDAY', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('tuesday', saturday), isFalse);
    });

    test('matches Arabic weekday names', () {
      expect(ScheduleTimeUtils.isDayOrDateMatch('السبت', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('سبت', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('الثلاثاء', saturday), isFalse);
      expect(ScheduleTimeUtils.isDayOrDateMatch('الثلاثاء', tuesday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('ثلاثاء', tuesday), isTrue);
    });

    test('matches ISO date strings', () {
      expect(ScheduleTimeUtils.isDayOrDateMatch('2026-10-24', saturday), isTrue);
      expect(ScheduleTimeUtils.isDayOrDateMatch('2026-10-27', saturday), isFalse);
      expect(ScheduleTimeUtils.isDayOrDateMatch('2026-10-27', tuesday), isTrue);
    });
  });

  group('ScheduleTimeUtils - isScheduleDue scenarios', () {
    test('Scenario 1: Lesson on different weekday is not due', () {
      // Current day is Saturday, lesson is Tuesday 06:24 AM
      final nowSaturday = DateTime(2026, 10, 24, 6, 25);
      final isDue = ScheduleTimeUtils.isScheduleDue(
        dayOrDate: 'tuesday',
        startTime: '06:24',
        endTime: '07:25',
        now: nowSaturday,
      );
      expect(isDue, isFalse);
    });

    test('Scenario 2: Correct day but outside start window is not due', () {
      // Saturday class 06:24 - 07:25 evaluated at 05:30 (before window)
      final earlyTime = DateTime(2026, 10, 24, 5, 30);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '06:24',
          endTime: '07:25',
          now: earlyTime,
        ),
        isFalse,
      );

      // Evaluated at 08:00 (after window)
      final lateTime = DateTime(2026, 10, 24, 8, 0);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '06:24',
          endTime: '07:25',
          now: lateTime,
        ),
        isFalse,
      );
    });

    test('Scenario 3: Correct day inside start window is due', () {
      // 15 min before 06:24 is 06:09
      final windowOpenTime = DateTime(2026, 10, 24, 6, 10);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '06:24',
          endTime: '07:25',
          now: windowOpenTime,
        ),
        isTrue,
      );

      // In the middle of class at 06:50
      final midClassTime = DateTime(2026, 10, 24, 6, 50);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '06:24',
          endTime: '07:25',
          now: midClassTime,
        ),
        isTrue,
      );

      // Exactly at end time 07:25
      final endTime = DateTime(2026, 10, 24, 7, 25);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '06:24',
          endTime: '07:25',
          now: endTime,
        ),
        isTrue,
      );
    });

    test('Scenario 7A: Pre-midnight window opening for early morning lesson', () {
      // Saturday 00:05 lesson opens 15 min before: Friday 23:50
      final fridayNightBeforeWindow = DateTime(2026, 10, 23, 23, 40);
      final fridayNightInWindow = DateTime(2026, 10, 23, 23, 55);

      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '00:05',
          endTime: '01:05',
          now: fridayNightBeforeWindow,
        ),
        isFalse,
      );

      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '00:05',
          endTime: '01:05',
          now: fridayNightInWindow,
        ),
        isTrue,
      );

      // And on Saturday morning at 00:10
      final saturdayMorning = DateTime(2026, 10, 24, 0, 10);
      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'saturday',
          startTime: '00:05',
          endTime: '01:05',
          now: saturdayMorning,
        ),
        isTrue,
      );
    });

    test('Scenario 7B: Post-midnight continuation for late night lesson', () {
      // Friday 23:30 - 00:30 (Saturday)
      final saturday0015 = DateTime(2026, 10, 24, 0, 15);
      final saturday0045 = DateTime(2026, 10, 24, 0, 45);

      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'friday',
          startTime: '23:30',
          endTime: '00:30',
          now: saturday0015,
        ),
        isTrue,
      );

      expect(
        ScheduleTimeUtils.isScheduleDue(
          dayOrDate: 'friday',
          startTime: '23:30',
          endTime: '00:30',
          now: saturday0045,
        ),
        isFalse,
      );
    });
  });

  group('ScheduleTimeUtils - resolveOccurrenceDate across midnight & timezone', () {
    test(
      'Saturday 00:05 lesson started on Friday at 23:50 resolves Saturday date',
      () {
        final friday2350 = DateTime(2026, 10, 23, 23, 50);
        final date = ScheduleTimeUtils.resolveOccurrenceDate(
          dayOrDate: 'saturday',
          startTime: '00:05',
          endTime: '01:05',
          nowInTimezone: friday2350,
        );
        expect(date, '2026-10-24');
      },
    );

    test(
      'Friday 23:30 lesson continuing into Saturday at 00:15 retains Friday date',
      () {
        final saturday0015 = DateTime(2026, 10, 24, 0, 15);
        final date = ScheduleTimeUtils.resolveOccurrenceDate(
          dayOrDate: 'friday',
          startTime: '23:30',
          endTime: '00:30',
          nowInTimezone: saturday0015,
        );
        expect(date, '2026-10-23');
      },
    );

    test(
      'Friday 23:30 lesson with default duration crossing midnight retains Friday date',
      () {
        final saturday0015 = DateTime(2026, 10, 24, 0, 15);
        final date = ScheduleTimeUtils.resolveOccurrenceDate(
          dayOrDate: 'friday',
          startTime: '23:30',
          endTime: null,
          nowInTimezone: saturday0015,
        );
        expect(date, '2026-10-23');
      },
    );

    test('UTC timestamp converted to timezone avoids 1-day error vs raw UTC', () {
      // 22:30 UTC on Oct 23 is 01:30 AM on Oct 24 in Asia/Riyadh (UTC+3)
      final utcTimestamp = DateTime.utc(2026, 10, 23, 22, 30);
      final occurrenceDate = ScheduleTimeUtils.resolveOccurrenceDateFromUtc(
        utcTimestamp,
        timezoneName: 'Asia/Riyadh',
      );
      expect(occurrenceDate, '2026-10-24');
    });
  });
}
