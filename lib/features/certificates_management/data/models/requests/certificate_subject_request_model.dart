class CertificateSubjectRequestModel {
  const CertificateSubjectRequestModel({
    required this.subjectId,
    required this.maxScore,
    required this.score,
  });

  final String subjectId;
  final num maxScore;
  final num score;

  Map<String, dynamic> toJson() {
    return {'subjectId': subjectId, 'maxScore': maxScore, 'score': score};
  }
}
