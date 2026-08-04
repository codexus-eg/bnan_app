class LessonUiModel {
  const LessonUiModel({
    required this.id,
    required this.classroomId,
    required this.classroomName,
    required this.subjectId,
    required this.subjectName,
    required this.day,
    required this.startTime,
  });

  final String id;
  final String classroomId;
  final String classroomName;
  final String subjectId;
  final String subjectName;
  final String day;
  final String startTime;

  LessonUiModel copyWith({String? day, String? startTime}) {
    return LessonUiModel(
      id: id,
      classroomId: classroomId,
      classroomName: classroomName,
      subjectId: subjectId,
      subjectName: subjectName,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
    );
  }
}

class LessonClassroomUiModel {
  const LessonClassroomUiModel({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.subjectName,
  });

  final String id;
  final String name;
  final String subjectId;
  final String subjectName;
}
