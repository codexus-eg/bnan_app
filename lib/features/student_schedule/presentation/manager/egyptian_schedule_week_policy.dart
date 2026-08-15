DateTime egyptianWeekStart(DateTime currentStart, int delta) =>
    currentStart.add(Duration(days: delta * 7));

int egyptianMaxWeek(int currentWeek, String? timezone, [DateTime? now]) {
  final current = timezone == 'Africa/Cairo'
      ? _cairoNow(now)
      : now ?? DateTime.now();
  return current.weekday >= DateTime.friday ? currentWeek + 1 : currentWeek;
}

String egyptianApiDate(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

DateTime _cairoNow([DateTime? value]) {
  final utc = (value ?? DateTime.now()).toUtc();
  final shifted = utc.add(Duration(hours: _cairoDst(utc) ? 3 : 2));
  return DateTime(shifted.year, shifted.month, shifted.day, shifted.hour);
}

bool _cairoDst(DateTime utc) {
  final start = _lastWeekday(
    utc.year,
    DateTime.april,
    DateTime.friday,
  ).subtract(const Duration(hours: 2));
  final end = _lastWeekday(
    utc.year,
    DateTime.october,
    DateTime.thursday,
  ).add(const Duration(hours: 21));
  return !utc.isBefore(start) && utc.isBefore(end);
}

DateTime _lastWeekday(int year, int month, int weekday) {
  var value = DateTime.utc(year, month + 1, 0);
  while (value.weekday != weekday) {
    value = value.subtract(const Duration(days: 1));
  }
  return value;
}
