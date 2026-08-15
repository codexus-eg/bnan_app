class DigitalScheduleGridData {
  const DigitalScheduleGridData({
    required this.days,
    required this.times,
    required this.cells,
    this.timeLabels = const {},
  });

  final List<String> days, times;
  final Map<String, List<DigitalScheduleGridItem>> cells;
  final Map<String, String> timeLabels;

  List<DigitalScheduleGridItem> items(String day, String time) =>
      cells['$day|$time'] ?? const [];

  String timeLabel(String time) => timeLabels[time] ?? time;
}

class DigitalScheduleGridItem {
  const DigitalScheduleGridItem(
    this.primary,
    this.secondary, {
    this.actionClassroomId,
  });
  final String primary, secondary;
  final String? actionClassroomId;
}
