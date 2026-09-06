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
    this.supervisor,
    this.meetingLink = '',
  });

  final String id;
  final String name;
  final ClassroomLookupModel curriculum;
  final ClassroomLookupModel grade;
  final List<ClassroomTeacherModel> teachers;
  final bool isActive;
  final int approvedStudentsCount;
  final int assignedTeachersCount;
  final ClassroomSupervisorModel? supervisor;
  final String meetingLink;

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
    final rawSupervisor = json['supervisor'];
    ClassroomSupervisorModel? supervisor;
    if (rawSupervisor is Map<String, dynamic>) {
      supervisor = ClassroomSupervisorModel.fromJson(rawSupervisor);
    } else if (rawSupervisor is Map) {
      supervisor = ClassroomSupervisorModel.fromJson(
        Map<String, dynamic>.from(rawSupervisor),
      );
    } else if (rawSupervisor != null && rawSupervisor.toString().isNotEmpty) {
      supervisor = ClassroomSupervisorModel(
        id: rawSupervisor.toString(),
        name: '',
      );
    } else if (json['supervisorId'] != null) {
      supervisor = ClassroomSupervisorModel(
        id: json['supervisorId'].toString(),
        name: '',
      );
    }

    return ClassroomModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      curriculum: ClassroomLookupModel.fromJson(json['curriculum'] ?? {}),
      grade: ClassroomLookupModel.fromJson(json['grade'] ?? {}),
      teachers: (json['teachers'] as List<dynamic>? ?? [])
          .map((e) => ClassroomTeacherModel.fromJson(e))
          .toList(),
      isActive: json['isActive'] ?? false,
      approvedStudentsCount: json['approvedStudentsCount'] ?? 0,
      assignedTeachersCount: json['assignedTeachersCount'] ?? 0,
      supervisor: supervisor,
      meetingLink: json['meetingLink']?.toString() ?? '',
    );
  }
}

class ClassroomSupervisorModel {
  const ClassroomSupervisorModel({required this.id, required this.name});

  final String id;
  final String name;

  factory ClassroomSupervisorModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final userMap = json['user'] is Map ? json['user'] as Map : null;
    final userFullName =
        userMap?['fullName']?.toString() ?? userMap?['name']?.toString() ?? '';
    final name =
        json['name']?.toString() ??
        json['fullName']?.toString() ??
        userFullName;
    return ClassroomSupervisorModel(id: id, name: name);
  }
}

class ClassroomLookupModel {
  const ClassroomLookupModel({
    required this.id,
    required this.name,
    this.registrationMode,
  });

  final String id;
  final String name;
  final String? registrationMode;

  factory ClassroomLookupModel.fromJson(Map<String, dynamic> json) {
    return ClassroomLookupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      registrationMode: json['registrationMode']?.toString().trim(),
    );
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
