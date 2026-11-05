import 'package:timezone/data/latest.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

abstract final class ScheduleTimeUtils {
  static final _pattern = RegExp(r'^(?:[01]?\d|2[0-3]):[0-5]\d(?::[0-5]\d)?$');
  static bool _timezonesInitialized = false;

  static void ensureTimezonesInitialized() {
    if (!_timezonesInitialized) {
      timezone_data.initializeTimeZones();
      _timezonesInitialized = true;
    }
  }

  static bool isValid(String value) =>
      _pattern.hasMatch(value.trim()) || minutes(value) != null;

  static bool isEndAfter(String startTime, String endTime) {
    final start = minutes(startTime);
    final end = minutes(endTime);
    return start != null && end != null && end > start;
  }

  static int? minutes(String? value) {
    if (value == null) return null;
    final trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty) return null;

    final isPm = trimmed.contains('pm') || trimmed.contains('م');
    final isAm = trimmed.contains('am') || trimmed.contains('ص');
    final clean = trimmed.replaceAll(RegExp(r'[^\d:]'), '').trim();
    if (clean.isEmpty) return null;

    final parts = clean.split(':');
    if (parts.isEmpty) return null;

    var hour = int.tryParse(parts[0]);
    final minute = parts.length > 1 ? int.tryParse(parts[1]) : 0;
    if (hour == null || minute == null) return null;

    if (isPm && hour < 12) {
      hour += 12;
    } else if (isAm && hour == 12) {
      hour = 0;
    }

    return hour * 60 + minute;
  }

  static String format12Hour(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final total = minutes(value);
    if (total == null) return value;

    final hour24 = total ~/ 60;
    final minute = (total % 60).toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;

    return '${hour12.toString().padLeft(2, '0')}:$minute $period';
  }

  static String range(String startTime, String? endTime) {
    final start = format12Hour(startTime);
    final end = endTime?.trim();

    if (end == null || end.isEmpty) {
      return start;
    }

    return '$start - ${format12Hour(end)}';
  }

  static bool isDueNow(
    String startTime,
    String? endTime, {
    int windowBeforeMinutes = 15,
    int defaultDurationMinutes = 60,
    DateTime? now,
  }) {
    final start = minutes(startTime);
    if (start == null) return false;
    final current = now ?? DateTime.now();
    final nowMins = current.hour * 60 + current.minute;
    final rawEnd = minutes(endTime);
    final end = rawEnd ?? (start + defaultDurationMinutes);

    if (rawEnd != null && rawEnd < start) {
      final windowStart = start - windowBeforeMinutes;
      return nowMins >= windowStart || nowMins <= end;
    }

    final windowStart = start - windowBeforeMinutes;
    if (windowStart < 0) {
      final prevDayWindowStart = 1440 + windowStart;
      return nowMins >= prevDayWindowStart || nowMins <= end;
    }

    return nowMins >= windowStart && nowMins <= end;
  }

  static bool isScheduleDue({
    required String dayOrDate,
    required String startTime,
    String? endTime,
    DateTime? now,
    int windowBeforeMinutes = 15,
    int defaultDurationMinutes = 60,
  }) {
    final current = now ?? DateTime.now();
    return resolveOccurrenceDate(
      dayOrDate: dayOrDate,
      startTime: startTime,
      endTime: endTime,
      nowInTimezone: current,
      windowBeforeMinutes: windowBeforeMinutes,
      defaultDurationMinutes: defaultDurationMinutes,
    ) != null;
  }

  static String? resolveOccurrenceDate({
    required String dayOrDate,
    required String startTime,
    String? endTime,
    required DateTime nowInTimezone,
    int windowBeforeMinutes = 15,
    int defaultDurationMinutes = 60,
  }) {
    final start = minutes(startTime);
    if (start == null) return null;
    final nowMins = nowInTimezone.hour * 60 + nowInTimezone.minute;
    final rawEnd = minutes(endTime);
    final end = rawEnd ?? (start + defaultDurationMinutes);
    final crossesMidnight = (rawEnd != null && rawEnd < start) ||
        (rawEnd == null && (start + defaultDurationMinutes) >= 1440);
    final nextDayEndMins = (rawEnd != null && rawEnd < start)
        ? rawEnd
        : (start + defaultDurationMinutes - 1440);

    // Case 1: Same calendar day match
    if (isDayOrDateMatch(dayOrDate, nowInTimezone)) {
      if (crossesMidnight) {
        final windowStart = start - windowBeforeMinutes;
        if (nowMins >= windowStart) return formatIsoDate(nowInTimezone);
        return null;
      }
      final windowStart = start - windowBeforeMinutes;
      if (windowStart < 0) {
        if (nowMins <= end) return formatIsoDate(nowInTimezone);
        return null;
      }
      if (nowMins >= windowStart && nowMins <= end) {
        return formatIsoDate(nowInTimezone);
      }
      return null;
    }

    // Case 2: Tomorrow's early-morning lesson whose window opens before midnight today
    final windowStart = start - windowBeforeMinutes;
    if (windowStart < 0) {
      final tomorrow = nowInTimezone.add(const Duration(days: 1));
      if (isDayOrDateMatch(dayOrDate, tomorrow)) {
        final prevDayWindowStart = 1440 + windowStart;
        if (nowMins >= prevDayWindowStart) return formatIsoDate(tomorrow);
      }
    }

    // Case 3: Yesterday's late-night lesson that crosses midnight into today
    if (crossesMidnight) {
      final yesterday = nowInTimezone.subtract(const Duration(days: 1));
      if (isDayOrDateMatch(dayOrDate, yesterday)) {
        if (nowMins <= nextDayEndMins) return formatIsoDate(yesterday);
      }
    }

    return null;
  }

  static String resolveOccurrenceDateFromUtc(
    DateTime timestamp, {
    String? timezoneName,
  }) {
    final tz = timezoneName?.trim();
    if (tz != null && tz.isNotEmpty) {
      try {
        ensureTimezonesInitialized();
        final location = timezone.getLocation(tz);
        final tzDate = timezone.TZDateTime.from(timestamp, location);
        return formatIsoDate(tzDate);
      } catch (_) {}
    }
    final local = timestamp.toLocal();
    return formatIsoDate(local);
  }

  static String formatIsoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static bool isDayOrDateMatch(String dayOrDate, DateTime date) {
    final trimmed = dayOrDate.trim().toLowerCase();
    if (trimmed.isEmpty) return false;

    final iso = formatIsoDate(date);
    if (trimmed == iso ||
        trimmed.startsWith('$iso ') ||
        trimmed.startsWith('${iso}t')) {
      return true;
    }

    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) {
      final local = parsed.isUtc ? parsed.toLocal() : parsed;
      return local.year == date.year &&
          local.month == date.month &&
          local.day == date.day;
    }

    final todayWeekday = weekdayName(date.weekday);
    final targetWeekday = normalizeWeekday(trimmed);
    return targetWeekday != null && targetWeekday == todayWeekday;
  }

  static String weekdayName(int weekday) => switch (weekday) {
    DateTime.saturday => 'saturday',
    DateTime.sunday => 'sunday',
    DateTime.monday => 'monday',
    DateTime.tuesday => 'tuesday',
    DateTime.wednesday => 'wednesday',
    DateTime.thursday => 'thursday',
    DateTime.friday => 'friday',
    _ => '',
  };

  static String? normalizeWeekday(String value) {
    final day = value.trim().toLowerCase();
    const validDays = [
      'saturday',
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
    ];
    if (validDays.contains(day)) return day;
    return switch (day) {
      'السبت' || 'سبت' => 'saturday',
      'الأحد' || 'الاحد' || 'أحد' || 'احد' => 'sunday',
      'الاثنين' || 'الإثنين' || 'اثنين' || 'إثنين' => 'monday',
      'الثلاثاء' || 'ثلاثاء' => 'tuesday',
      'الأربعاء' || 'الاربعاء' || 'أربعاء' || 'اربعاء' => 'wednesday',
      'الخميس' || 'خميس' => 'thursday',
      'الجمعة' || 'جمعة' => 'friday',
      _ => null,
    };
  }
}