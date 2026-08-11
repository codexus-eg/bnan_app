import 'package:bnan_app/core/enums/registration_mode.dart';

class ParentChildCurriculumModel {
  const ParentChildCurriculumModel({
    required this.id,
    this.name = '',
    this.registrationMode,
  });

  final String id;
  final String name;
  final RegistrationMode? registrationMode;

  factory ParentChildCurriculumModel.fromChildJson(Map<String, dynamic> json) {
    final classroom = json['classroom'];
    final grade = classroom is Map ? classroom['grade'] : null;
    final raw =
        json['curriculum'] ??
        json['curriculumId'] ??
        (grade is Map ? grade['curriculum'] : null);
    if (raw is Map) {
      final value = Map<String, dynamic>.from(raw);
      return ParentChildCurriculumModel(
        id: (value['id'] ?? value['_id'])?.toString() ?? '',
        name: value['name']?.toString() ?? '',
        registrationMode: RegistrationMode.fromValue(value['registrationMode']),
      );
    }
    return ParentChildCurriculumModel(id: raw?.toString() ?? '');
  }
}
