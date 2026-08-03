class TeachingAssignmentsResponseModel {
  final bool success;
  final int length;
  final List<TeachingAssignmentItem> data;

  const TeachingAssignmentsResponseModel({
    required this.success,
    required this.length,
    required this.data,
  });

  factory TeachingAssignmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return TeachingAssignmentsResponseModel(
      success: json['success'] == true,
      length: _asInt(json['length']),
      data: _asList(
        json['data'],
      ).map((item) => TeachingAssignmentItem.fromJson(item)).toList(),
    );
  }
}

class TeachingAssignmentItem {
  final TeacherInfo teacher;
  final List<TeachingCurriculumModel> curriculums;

  const TeachingAssignmentItem({
    required this.teacher,
    required this.curriculums,
  });

  factory TeachingAssignmentItem.fromJson(Map<String, dynamic> json) {
    return TeachingAssignmentItem(
      teacher: TeacherInfo.fromJson(_asMap(json['teacher'])),
      curriculums: _asList(
        json['curriculums'],
      ).map((item) => TeachingCurriculumModel.fromJson(item)).toList(),
    );
  }

  List<TeachingAssignmentRowModel> get assignmentRows {
    final rows = <TeachingAssignmentRowModel>[];

    for (final curriculum in curriculums) {
      for (final grade in curriculum.grades) {
        for (final subject in grade.subjects) {
          for (final classroom in subject.classrooms) {
            rows.add(
              TeachingAssignmentRowModel(
                curriculumId: curriculum.id,
                curriculumName: curriculum.name,
                gradeId: grade.id,
                gradeName: grade.name,
                subjectId: subject.id,
                subjectName: subject.name,
                classroomId: classroom.id,
                classroomName: classroom.name,
                assignmentId: classroom.assignmentId,
              ),
            );
          }
        }
      }
    }

    return rows;
  }
}

class TeacherInfo {
  final String id;
  final String name;
  final String email;
  final String status;

  const TeacherInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
  });

  factory TeacherInfo.fromJson(Map<String, dynamic> json) {
    return TeacherInfo(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['name']),
      email: _asString(json['email']),
      status: _asString(json['status']),
    );
  }

  String get displayName => name.isEmpty ? 'بدون اسم' : name;

  String get displayEmail => email.isEmpty ? 'بدون بريد إلكتروني' : email;
}

class TeachingCurriculumModel {
  final String id;
  final String name;
  final List<TeachingGradeModel> grades;

  const TeachingCurriculumModel({
    required this.id,
    required this.name,
    required this.grades,
  });

  factory TeachingCurriculumModel.fromJson(Map<String, dynamic> json) {
    return TeachingCurriculumModel(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['name']),
      grades: _asList(
        json['grades'],
      ).map((item) => TeachingGradeModel.fromJson(item)).toList(),
    );
  }
}

class TeachingGradeModel {
  final String id;
  final String name;
  final List<TeachingSubjectModel> subjects;

  const TeachingGradeModel({
    required this.id,
    required this.name,
    required this.subjects,
  });

  factory TeachingGradeModel.fromJson(Map<String, dynamic> json) {
    return TeachingGradeModel(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['name']),
      subjects: _asList(
        json['subjects'],
      ).map((item) => TeachingSubjectModel.fromJson(item)).toList(),
    );
  }
}

class TeachingSubjectModel {
  final String id;
  final String name;
  final List<TeachingClassroomModel> classrooms;

  const TeachingSubjectModel({
    required this.id,
    required this.name,
    required this.classrooms,
  });

  factory TeachingSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeachingSubjectModel(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['name']),
      classrooms: _asList(
        json['classrooms'],
      ).map((item) => TeachingClassroomModel.fromJson(item)).toList(),
    );
  }
}

class TeachingClassroomModel {
  final String id;
  final String name;
  final String assignmentId;

  const TeachingClassroomModel({
    required this.id,
    required this.name,
    required this.assignmentId,
  });

  factory TeachingClassroomModel.fromJson(Map<String, dynamic> json) {
    return TeachingClassroomModel(
      id: _asString(json['_id'] ?? json['id']),
      name: _asString(json['name']),
      assignmentId: _asString(json['assignmentId']),
    );
  }
}

class TeachingAssignmentRowModel {
  final String curriculumId;
  final String curriculumName;
  final String gradeId;
  final String gradeName;
  final String subjectId;
  final String subjectName;
  final String classroomId;
  final String classroomName;
  final String assignmentId;

  const TeachingAssignmentRowModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.gradeId,
    required this.gradeName,
    required this.subjectId,
    required this.subjectName,
    required this.classroomId,
    required this.classroomName,
    required this.assignmentId,
  });
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().toList();
  }
  return [];
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  return {};
}

String _asString(dynamic value) {
  return value?.toString().trim() ?? '';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
