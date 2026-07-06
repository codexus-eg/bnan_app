class ClassroomModel {
  const ClassroomModel({
    required this.id,
    required this.name,
    required this.curriculum,
    required this.grade,
    required this.teachers,
    required this.isActive,
    required this.approvedStudentsCount,
    required this.assignedTeachersCount,
  });

  final String id;
  final String name;
  final ClassroomLookupModel curriculum;
  final ClassroomLookupModel grade;
  final List<ClassroomTeacherModel> teachers;
  final bool isActive;
  final int approvedStudentsCount;
  final int assignedTeachersCount;

  static const List<ClassroomModel> skeletonClassrooms = [
    ClassroomModel(
      id: 'skeleton-1',
      name: 'Classroom name',
      curriculum: ClassroomLookupModel(id: 'curriculum', name: 'Curriculum'),
      grade: ClassroomLookupModel(id: 'grade', name: 'Grade'),
      teachers: [
        ClassroomTeacherModel(id: 'teacher', fullName: 'Teacher name'),
      ],
      isActive: true,
      approvedStudentsCount: 12,
      assignedTeachersCount: 1,
    ),
    ClassroomModel(
      id: 'skeleton-2',
      name: 'Classroom name',
      curriculum: ClassroomLookupModel(id: 'curriculum', name: 'Curriculum'),
      grade: ClassroomLookupModel(id: 'grade', name: 'Grade'),
      teachers: [
        ClassroomTeacherModel(id: 'teacher', fullName: 'Teacher name'),
      ],
      isActive: true,
      approvedStudentsCount: 12,
      assignedTeachersCount: 1,
    ),
  ];

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      curriculum: ClassroomLookupModel.fromJson(json['curriculum'] ?? {}),
      grade: ClassroomLookupModel.fromJson(json['grade'] ?? {}),
      teachers: (json['teachers'] as List<dynamic>? ?? [])
          .map((e) => ClassroomTeacherModel.fromJson(e))
          .toList(),
      isActive: json['isActive'] ?? false,
      approvedStudentsCount: json['approvedStudentsCount'] ?? 0,
      assignedTeachersCount: json['assignedTeachersCount'] ?? 0,
    );
  }
}

class ClassroomLookupModel {
  const ClassroomLookupModel({required this.id, required this.name});

  final String id;
  final String name;

  factory ClassroomLookupModel.fromJson(Map<String, dynamic> json) {
    return ClassroomLookupModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}

class ClassroomTeacherModel {
  const ClassroomTeacherModel({required this.id, required this.fullName});

  final String id;
  final String fullName;

  factory ClassroomTeacherModel.fromJson(Map<String, dynamic> json) {
    return ClassroomTeacherModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}
