class ClassModel {
  const ClassModel({
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
  final ClassLookupModel curriculum;
  final ClassLookupModel grade;
  final List<ClassTeacherModel> teachers;
  final bool isActive;
  final int approvedStudentsCount;
  final int assignedTeachersCount;

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      curriculum: ClassLookupModel.fromJson(json['curriculum'] ?? {}),
      grade: ClassLookupModel.fromJson(json['grade'] ?? {}),
      teachers: (json['teachers'] as List<dynamic>? ?? [])
          .map((e) => ClassTeacherModel.fromJson(e))
          .toList(),
      isActive: json['isActive'] ?? false,
      approvedStudentsCount: json['approvedStudentsCount'] ?? 0,
      assignedTeachersCount: json['assignedTeachersCount'] ?? 0,
    );
  }
}

class ClassLookupModel {
  const ClassLookupModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory ClassLookupModel.fromJson(Map<String, dynamic> json) {
    return ClassLookupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ClassTeacherModel {
  const ClassTeacherModel({
    required this.id,
    required this.fullName,
  });

  final String id;
  final String fullName;

  factory ClassTeacherModel.fromJson(Map<String, dynamic> json) {
    return ClassTeacherModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}