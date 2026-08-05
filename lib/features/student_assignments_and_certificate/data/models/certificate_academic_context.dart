import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';

class CertificateAcademicContext {
  const CertificateAcademicContext({
    required this.curriculum,
    required this.curriculumName,
    required this.grade,
    required this.gradeName,
  });

  factory CertificateAcademicContext.fromJson(Object? json) {
    final map = certificateMap(json);
    return CertificateAcademicContext(
      curriculum: certificateString(map['curriculum']),
      curriculumName: certificateString(map['curriculumNameSnapshot']),
      grade: certificateString(map['grade']),
      gradeName: certificateString(map['gradeNameSnapshot']),
    );
  }

  final String curriculum;
  final String curriculumName;
  final String grade;
  final String gradeName;
}
