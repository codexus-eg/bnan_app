import 'relation_parser.dart';

class CertificateAcademicContextModel {
  const CertificateAcademicContextModel({
    required this.curriculumId,
    required this.curriculumNameSnapshot,
    required this.gradeId,
    required this.gradeNameSnapshot,
  });

  final String? curriculumId;
  final String? curriculumNameSnapshot;
  final String? gradeId;
  final String? gradeNameSnapshot;

  factory CertificateAcademicContextModel.fromJson(Map<String, dynamic> json) {
    return CertificateAcademicContextModel(
      curriculumId: RelationParser.idOf(json['curriculum']),
      curriculumNameSnapshot: json['curriculumNameSnapshot']?.toString(),
      gradeId: RelationParser.idOf(json['grade']),
      gradeNameSnapshot: json['gradeNameSnapshot']?.toString(),
    );
  }
}
