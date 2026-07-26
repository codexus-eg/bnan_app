class CurriculumModel {
  const CurriculumModel({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.slug,
    this.registrationMode,
    this.baseCurriculum,
    this.createdAt,
    this.updatedAt,
    this.gradesCount,
  });

  final String id;
  final String name;
  final String? description;
  final String? icon;
  final String? slug;
  final String? registrationMode;
  final String? baseCurriculum;
  final String? createdAt;
  final String? updatedAt;
  final int? gradesCount;

  factory CurriculumModel.fromJson(Map<String, dynamic> json) {
    return CurriculumModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: (json['description'] ?? json['Description'])?.toString(),
      icon: json['icon']?.toString(),
      slug: json['slug']?.toString(),
      registrationMode: json['registrationMode']?.toString(),
      baseCurriculum: json['baseCurriculum']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      gradesCount: json['gradesCount'] as int?,
    );
  }

  static List<CurriculumModel> get placeholderList => const [
    CurriculumModel(
      id: '1',
      name: 'Saudi Curriculum',
      description: 'Curriculum description',
      gradesCount: 6,
    ),
    CurriculumModel(
      id: '2',
      name: 'Egyptian Curriculum',
      description: 'Curriculum description',
      gradesCount: 8,
    ),
    CurriculumModel(
      id: '3',
      name: 'Gulf Curriculum',
      description: 'Curriculum description',
      gradesCount: 5,
    ),
  ];
}