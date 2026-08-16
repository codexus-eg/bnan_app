abstract final class ScheduleTimeUtils {
  static final _pattern = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');

  static bool isValid(String value) => _pattern.hasMatch(value);

  static bool isEndAfter(String startTime, String endTime) {
    final start = minutes(startTime);
    final end = minutes(endTime);
    return start != null && end != null && end > start;
  }

  static int? minutes(String? value) {
    if (value == null || !isValid(value)) return null;

    final parts = value.split(':');

    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static String format12Hour(String? value) {
    if (value == null || !isValid(value)) {
      return value ?? '';
    }

    final parts = value.split(':');

    final hour = int.parse(parts[0]);
    final minute = parts[1];

    final period = hour >= 12 ? 'PM' : 'AM';

    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

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
}