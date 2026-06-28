class TeacherProfileResponseModel {
  final bool success;
  final TeacherProfileModel teacherProfile;

  TeacherProfileResponseModel({
    required this.success,
    required this.teacherProfile,
  });

  factory TeacherProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileResponseModel(
      success: json['success'] ?? false,
      teacherProfile: TeacherProfileModel.fromJson(json['data'] ?? {}),
    );
  }
}

class TeacherProfileModel {
  final String id;
  final TeacherProfileUserModel user;
  final String phone;
  final String specialization;
  final List<TeacherProfileItemModel> curriculums;
  final int grades;
  final List<TeacherProfileItemModel> subjects;
  final int classrooms;
  final int students;

  TeacherProfileModel({
    required this.id,
    required this.user,
    required this.phone,
    required this.specialization,
    required this.curriculums,
    required this.grades,
    required this.subjects,
    required this.classrooms,
    required this.students,
  });

  factory TeacherProfileModel.placeholder() {
    return TeacherProfileModel(
      id: '',
      user: TeacherProfileUserModel.placeholder(),
      phone: '+20 101 655 789',
      specialization: 'معلمة الرياضيات',
      curriculums: const [],
      grades: 4,
      subjects: const [],
      classrooms: 8,
      students: 12,
    );
  }

  factory TeacherProfileModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileModel(
      id: json['_id'] ?? '',
      user: TeacherProfileUserModel.fromJson(json['user'] ?? {}),
      phone: json['phone'] ?? '',
      specialization: json['specialization'] ?? '',
      curriculums: (json['curriculums'] as List? ?? [])
          .map((item) => TeacherProfileItemModel.fromJson(item))
          .toList(),
      grades: json['grades'] ?? 0,
      subjects: (json['subjects'] as List? ?? [])
          .map((item) => TeacherProfileItemModel.fromJson(item))
          .toList(),
      classrooms: json['classrooms'] ?? 0,
      students: json['students'] ?? 0,
    );
  }
}

class TeacherProfileUserModel {
  final String id;
  final String fullName;
  final String email;

  TeacherProfileUserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory TeacherProfileUserModel.placeholder() {
    return TeacherProfileUserModel(
      id: '',
      fullName: 'أ/ سارة عبدالله',
      email: 'sara@gmail.com',
    );
  }

  factory TeacherProfileUserModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileUserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class TeacherProfileItemModel {
  final String id;
  final String name;

  TeacherProfileItemModel({
    required this.id,
    required this.name,
  });

  factory TeacherProfileItemModel.fromJson(Map<String, dynamic> json) {
    return TeacherProfileItemModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}