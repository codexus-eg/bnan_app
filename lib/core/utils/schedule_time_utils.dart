abstract final class ScheduleTimeUtils {
  static final _pattern = RegExp(r'^(?:[01]?\d|2[0-3]):[0-5]\d(?::[0-5]\d)?$');

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
    final end = minutes(endTime) ?? (start + defaultDurationMinutes);
    return nowMins >= (start - windowBeforeMinutes) && nowMins <= end;
  }
}