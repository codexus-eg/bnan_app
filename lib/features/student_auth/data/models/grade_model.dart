import 'package:bnan_app/features/student_auth/data/models/subject_model.dart';

class GradesResponseModel {
  final bool success;
  final List<GradeModel> grades;

  const GradesResponseModel({required this.success, required this.grades});

  factory GradesResponseModel.fromJson(Map<String, dynamic> json) {
    return GradesResponseModel(
      success: json['success'] ?? false,
      grades: (json['data'] as List<dynamic>? ?? [])
          .map((item) => GradeModel.fromJson(item))
          .toList(),
    );
  }
}

class GradeModel {
  final String id;
  final String name;
  final String curriculum;
  final bool isActive;
  final List<SubjectModel> subjects;

  const GradeModel({
    required this.id,
    required this.name,
    required this.curriculum,
    required this.isActive,
    required this.subjects,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      curriculum: json['curriculum'] ?? '',
      isActive: json['isActive'] ?? false,
      subjects: (json['subjects'] as List<dynamic>? ?? [])
          .map((item) => SubjectModel.fromJson(item))
          .toList(),
    );
  }

  static List<GradeModel> placeholderList() {
    return const [
      GradeModel(
        id: '1',
        name: 'Grade name',
        curriculum: '',
        isActive: true,
        subjects: [],
      ),
      GradeModel(
        id: '2',
        name: 'Grade name',
        curriculum: '',
        isActive: true,
        subjects: [],
      ),
      GradeModel(
        id: '3',
        name: 'Grade name',
        curriculum: '',
        isActive: true,
        subjects: [],
      ),
    ];
  }
}
