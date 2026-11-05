class CourseScheduleSlot {
  const CourseScheduleSlot({
    this.slotId,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.subjectId,
    this.teacherId,
  });

  final String? slotId;
  final String day;
  final String startTime;
  final String endTime;
  final String? subjectId;
  final String? teacherId;

  factory CourseScheduleSlot.fromJson(Map<String, dynamic> json) =>
      CourseScheduleSlot(
        slotId: _text(
          json['slotId'] ?? json['slot_id'] ?? json['id'] ?? json['_id'],
        ),
        day: (json['day'] ?? '').toString().toLowerCase().trim(),
        startTime: (json['startTime'] ?? '').toString().trim(),
        endTime: (json['endTime'] ?? '').toString().trim(),
        subjectId: _text(json['subjectId'] ?? json['subject']),
        teacherId: _text(json['teacherId'] ?? json['teacher']),
      );

  Map<String, dynamic> toJson() => {
    if (slotId != null && slotId!.isNotEmpty) 'slotId': slotId,
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
  };

  static String? _text(Object? v) {
    final s = v?.toString().trim();
    return (s != null && s.isNotEmpty) ? s : null;
  }
}
