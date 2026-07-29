class LessonUiModel {
  const LessonUiModel({
    required this.id,
    required this.subjectName,
    required this.classroomName,
    required this.startTime,
    required this.endTime,
    this.isEmptySlot = false,
  });

  final String id;
  final String subjectName;
  final String classroomName;
  final String startTime;
  final String endTime;
  final bool isEmptySlot;
}