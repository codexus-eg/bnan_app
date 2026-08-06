import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';

class CertificateRecipientSnapshot {
  const CertificateRecipientSnapshot({required this.fullName});

  factory CertificateRecipientSnapshot.fromJson(Object? json) {
    return CertificateRecipientSnapshot(
      fullName: certificateString(certificateMap(json)['fullName']),
    );
  }

  final String fullName;
}
