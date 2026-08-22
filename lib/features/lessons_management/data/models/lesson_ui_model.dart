class LessonUiModel {
  const LessonUiModel({
    required this.id,
    required this.classroomId,
    required this.classroomName,
    required this.subjectId,
    required this.subjectName,
    required this.day,
    required this.startTime,
    this.endTime,
    this.teacherName,
    this.chatRoomId,
    this.classroomSubjectId,
    this.occurrenceKey,
  });

  final String id;
  final String classroomId;
  final String classroomName;
  final String subjectId;
  final String subjectName;
  final String day;
  final String startTime;
  final String? endTime;
  final String? teacherName;
  final String? chatRoomId;
  final String? classroomSubjectId;
  final String? occurrenceKey;

  LessonUiModel copyWith({String? day, String? startTime, String? endTime}) {
    return LessonUiModel(
      id: id,
      classroomId: classroomId,
      classroomName: classroomName,
      subjectId: subjectId,
      subjectName: subjectName,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacherName: teacherName,
      chatRoomId: chatRoomId,
      classroomSubjectId: classroomSubjectId,
      occurrenceKey: occurrenceKey,
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
