import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';

class CertificatePeriod {
  const CertificatePeriod({required this.month, required this.year});

  factory CertificatePeriod.fromJson(Object? json) {
    final map = certificateMap(json);
    return CertificatePeriod(
      month: certificateInt(map['month']),
      year: certificateInt(map['year']),
    );
  }

  final int month;
  final int year;
}
