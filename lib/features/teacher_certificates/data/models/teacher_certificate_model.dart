class TeacherCertificateModel {
  const TeacherCertificateModel({
    required this.imageUrl,
    required this.totalScore,
    required this.maxScore,
  });

  final String imageUrl;
  final int totalScore;
  final int maxScore;
}