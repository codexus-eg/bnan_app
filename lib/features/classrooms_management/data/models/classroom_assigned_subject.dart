class ClassroomAssignedSubject {
  const ClassroomAssignedSubject({
    required this.id,
    required this.classroomSubjectId,
    required this.subjectId,
    required this.name,
    this.teacherId,
    this.teacherName,
    this.isActive = true,
  });

  final String id;
  final String classroomSubjectId;
  final String subjectId;
  final String name;
  final String? teacherId;
  final String? teacherName;
  final bool isActive;

  String get effectiveClassroomSubjectId =>
      classroomSubjectId.isNotEmpty ? classroomSubjectId : id;

  factory ClassroomAssignedSubject.fromJson(Map<String, dynamic> json) {
    final rawTeacher = json['teacher'];
    String? tId;
    String? tName;
    if (rawTeacher is Map) {
      tId = rawTeacher['id']?.toString() ?? rawTeacher['_id']?.toString();
      tName =
          rawTeacher['fullName']?.toString() ?? rawTeacher['name']?.toString();
    } else if (rawTeacher != null) {
      tId = rawTeacher.toString();
    }

    final rawSubject = json['subject'];
    String subId = json['subjectId']?.toString() ?? '';
    String subName = json['name']?.toString() ?? '';
    if (rawSubject is Map) {
      if (subId.isEmpty) {
        subId =
            rawSubject['id']?.toString() ??
            rawSubject['_id']?.toString() ??
            '';
      }
      if (subName.isEmpty) subName = rawSubject['name']?.toString() ?? '';
    }

    return ClassroomAssignedSubject(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      classroomSubjectId:
          json['classroomSubjectId']?.toString() ??
          json['id']?.toString() ??
          '',
      subjectId: subId.isNotEmpty ? subId : (json['id']?.toString() ?? ''),
      name: subName,
      teacherId: tId,
      teacherName: tName,
      isActive: json['isActive'] ?? true,
    );
  }
}
