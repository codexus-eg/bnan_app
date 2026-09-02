class TeacherTermsModel {
  const TeacherTermsModel({
    required this.slug,
    required this.title,
    required this.content,
    required this.version,
    required this.updatedAt,
  });

  final String slug;
  final String title;
  final String content;
  final int version;
  final DateTime? updatedAt;

  factory TeacherTermsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return TeacherTermsModel(
      slug: data['slug'] as String? ?? '',
      title: data['title'] as String? ?? '',
      content: data['content'] as String? ?? '',
      version: data['version'] as int? ?? 0,
      updatedAt: DateTime.tryParse(data['updatedAt'] as String? ?? ''),
    );
  }
}
