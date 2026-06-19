class SubjectsResponseModel {
  final bool success;
  final List<SubjectModel> subjects;

  const SubjectsResponseModel({
    required this.success,
    required this.subjects,
  });

  factory SubjectsResponseModel.fromJson(Map<String, dynamic> json) {
    return SubjectsResponseModel(
      success: json['success'] ?? false,
      subjects: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SubjectModel.fromJson(item))
          .toList(),
    );
  }
}

class SubjectModel {
  final String id;
  final String name;
  final String grade;
  final String curriculum;
  final bool isActive;

  const SubjectModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.curriculum,
    required this.isActive,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      curriculum: json['curriculum'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }

  static List<SubjectModel> placeholderList() {
    return const [
      SubjectModel(
        id: '1',
        name: 'Subject name',
        grade: '',
        curriculum: '',
        isActive: true,
      ),
      SubjectModel(
        id: '2',
        name: 'Subject name',
        grade: '',
        curriculum: '',
        isActive: true,
      ),
      SubjectModel(
        id: '3',
        name: 'Subject name',
        grade: '',
        curriculum: '',
        isActive: true,
      ),
      SubjectModel(
        id: '4',
        name: 'Subject name',
        grade: '',
        curriculum: '',
        isActive: true,
      ),
    ];
  }
}