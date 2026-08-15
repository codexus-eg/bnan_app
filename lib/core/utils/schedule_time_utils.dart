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

  static String range(String startTime, String? endTime) {
    final end = endTime?.trim();
    return end == null || end.isEmpty ? startTime : '$startTime - $end';
  }
}
