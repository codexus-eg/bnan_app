class DigitalScheduleGridData {
  const DigitalScheduleGridData({
    required this.days,
    required this.times,
    required this.cells,
  });

  final List<String> days, times;
  final Map<String, List<DigitalScheduleGridItem>> cells;

  List<DigitalScheduleGridItem> items(String day, String time) =>
      cells['$day|$time'] ?? const [];
}

class DigitalScheduleGridItem {
  const DigitalScheduleGridItem(this.primary, this.secondary);
  final String primary, secondary;
}
