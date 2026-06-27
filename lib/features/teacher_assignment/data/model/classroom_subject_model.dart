class ClassroomSubjectModel {
  final String id;
  final String classroom;
  final List<String> subjects;

  const ClassroomSubjectModel({
    required this.id,
    required this.classroom,
    required this.subjects,
  });

  factory ClassroomSubjectModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'];

    return ClassroomSubjectModel(
      id: json['id'] ?? '',
      classroom: json['classroom'] ?? '',
      subjects: subject != null
          ? [subject]
          : List<String>.from(json['subjects'] ?? []),
    );
  }
}