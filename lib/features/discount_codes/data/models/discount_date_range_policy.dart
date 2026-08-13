abstract class DiscountDateRangePolicy {
  static bool endsBeforeStart(DateTime start, DateTime end) =>
      dateOnly(end).isBefore(dateOnly(start));

  static bool isExpired(DateTime? end, {DateTime? now}) =>
      end != null && dateOnly(end).isBefore(dateOnly(now ?? DateTime.now()));

  static DateTime dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
