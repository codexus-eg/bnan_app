class SubjectDetailsModel {
  final String id;
  final String name;

  const SubjectDetailsModel({
    required this.id,
    required this.name,
  });

  factory SubjectDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return SubjectDetailsModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
    );
  }
}