import 'relation_parser.dart';

class CertificateSubjectModel {
  const CertificateSubjectModel({
    required this.subjectId,
    required this.nameSnapshot,
    required this.maxScore,
    required this.score,
  });

  final String? subjectId;
  final String? nameSnapshot;
  final num? maxScore;
  final num? score;

  factory CertificateSubjectModel.fromJson(Map<String, dynamic> json) {
    return CertificateSubjectModel(
      subjectId: RelationParser.idOf(json['subject']),
      nameSnapshot: json['nameSnapshot']?.toString(),
      maxScore: num.tryParse(json['maxScore']?.toString() ?? ''),
      score: num.tryParse(json['score']?.toString() ?? ''),
    );
  }
}
