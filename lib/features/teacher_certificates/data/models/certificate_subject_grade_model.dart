class CertificateSubjectGradeModel {
  const CertificateSubjectGradeModel({
    required this.subjectName,
    required this.studentDegree,
    required this.maxDegree,
  });

  final String subjectName;
  final int studentDegree;
  final int maxDegree;
}