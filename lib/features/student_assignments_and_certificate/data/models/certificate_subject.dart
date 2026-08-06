import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';

class CertificateSubject {
  const CertificateSubject({
    required this.subject,
    required this.name,
    required this.maxScore,
    required this.score,
  });

  factory CertificateSubject.fromJson(Object? json) {
    final map = certificateMap(json);
    return CertificateSubject(
      subject: certificateString(map['subject']),
      name: certificateString(map['nameSnapshot']),
      maxScore: certificateDouble(map['maxScore']),
      score: certificateDouble(map['score']),
    );
  }

  final String subject;
  final String name;
  final double maxScore;
  final double score;
}
