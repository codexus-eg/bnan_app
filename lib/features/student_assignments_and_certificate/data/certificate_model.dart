import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_academic_context.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_parsing.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_period.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_recipient_snapshot.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/certificate_subject.dart';

class CertificateModel {
  const CertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.recipient,
    required this.period,
    required this.academicContext,
    required this.recipientSnapshot,
    required this.subjects,
    required this.totalScore,
    required this.totalMaxScore,
    required this.percentage,
    required this.previewImagePath,
    required this.issuedAt,
    required this.pdfPath,
  });

  factory CertificateModel.fromJson(Object? json) {
    final map = certificateMap(json);
    final subjects = certificateList(
      map['subjects'],
    ).map(CertificateSubject.fromJson).toList(growable: false);
    return CertificateModel(
      id: certificateString(map['_id']),
      certificateNumber: certificateString(map['certificateNumber']),
      certificateType: certificateString(map['certificateType']),
      recipient: certificateString(map['recipient']),
      period: CertificatePeriod.fromJson(map['period']),
      academicContext: CertificateAcademicContext.fromJson(
        map['academicContext'],
      ),
      recipientSnapshot: CertificateRecipientSnapshot.fromJson(
        map['recipientSnapshot'],
      ),
      subjects: subjects,
      totalScore: certificateDouble(map['totalScore']),
      totalMaxScore: certificateDouble(map['totalMaxScore']),
      percentage: certificateDouble(map['percentage']),
      previewImagePath: certificateString(map['previewImagePath']),
      issuedAt: DateTime.tryParse(certificateString(map['issuedAt'])),
      pdfPath: certificateString(map['pdfPath']),
    );
  }

  factory CertificateModel.placeholder() =>
      CertificateModel.fromJson(const <String, Object?>{});

  final String id;
  final String certificateNumber;
  final String certificateType;
  final String recipient;
  final CertificatePeriod period;
  final CertificateAcademicContext academicContext;
  final CertificateRecipientSnapshot recipientSnapshot;
  final List<CertificateSubject> subjects;
  final double totalScore;
  final double totalMaxScore;
  final double percentage;
  final String previewImagePath;
  final DateTime? issuedAt;
  final String pdfPath;
}
