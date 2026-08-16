import 'package:bnan_app/features/certificates_management/data/models/certificate_period_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/relation_parser.dart';

class TeacherCertificateModel {
  const TeacherCertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.teacherName,
    required this.period,
    required this.previewImagePath,
    required this.pdfPath,
    required this.issuedAt,
  });

  final String id, certificateNumber, certificateType, teacherName;
  final String previewImagePath, pdfPath;
  final CertificatePeriodModel? period;
  final DateTime? issuedAt;

  factory TeacherCertificateModel.fromJson(Map<String, dynamic> json) {
    final teacher = RelationParser.mapOf(json['teacher']) ?? const {};
    final period = RelationParser.mapOf(json['period']);
    return TeacherCertificateModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      certificateNumber: json['certificateNumber']?.toString() ?? '',
      certificateType: json['certificateType']?.toString() ?? '',
      teacherName: teacher['fullName']?.toString() ?? '',
      period: period == null ? null : CertificatePeriodModel.fromJson(period),
      previewImagePath: json['previewImagePath']?.toString() ?? '',
      pdfPath: json['pdfPath']?.toString() ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
    );
  }

  static const placeholders = [
    TeacherCertificateModel(
      id: 'placeholder-1',
      certificateNumber: '',
      certificateType: 'ideal_teacher',
      teacherName: 'Teacher Name',
      period: null,
      previewImagePath: '',
      pdfPath: '',
      issuedAt: null,
    ),
    TeacherCertificateModel(
      id: 'placeholder-2',
      certificateNumber: '',
      certificateType: 'general_teacher',
      teacherName: 'Teacher Name',
      period: null,
      previewImagePath: '',
      pdfPath: '',
      issuedAt: null,
    ),
  ];
}
