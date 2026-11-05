import 'package:bnan_app/features/certificates_management/data/models/certificate_period_model.dart';
import 'package:bnan_app/features/certificates_management/data/models/relation_parser.dart';

class TeacherCertificateModel {
  const TeacherCertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.teacherName,
    this.recipientName = '',
    this.status = 'draft',
    required this.period,
    required this.previewImagePath,
    required this.pdfPath,
    required this.issuedAt,
    this.createdAt,
  });

  final String id, certificateNumber, certificateType, teacherName;
  final String recipientName, status;
  final String previewImagePath, pdfPath;
  final CertificatePeriodModel? period;
  final DateTime? issuedAt;
  final DateTime? createdAt;

  bool get isDraft => status == 'draft';
  bool get isIssued => status == 'issued';
  bool get hasPdf => pdfPath.trim().isNotEmpty;

  factory TeacherCertificateModel.fromJson(Map<String, dynamic> json) {
    final teacher = RelationParser.mapOf(json['teacher']) ?? const {};
    final recipient = RelationParser.mapOf(json['recipientSnapshot']);
    final teacherName = json['teacherName']?.toString().trim() ??
        teacher['fullName']?.toString().trim() ??
        '';
    final rawRecipientName = json['recipientName']?.toString().trim();
    final snapshotRecipientName = recipient?['fullName']?.toString().trim();
    final recipientName =
        (rawRecipientName != null && rawRecipientName.isNotEmpty)
            ? rawRecipientName
            : ((snapshotRecipientName != null &&
                    snapshotRecipientName.isNotEmpty)
                ? snapshotRecipientName
                : teacherName);
    final rawStatus = json['status']?.toString().trim().toLowerCase();
    final status = rawStatus?.isNotEmpty == true
        ? rawStatus!
        : (json['pdfPath']?.toString().trim().isNotEmpty == true
            ? 'issued'
            : 'draft');
    final period = RelationParser.mapOf(json['period']);
    return TeacherCertificateModel(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      certificateNumber: json['certificateNumber']?.toString() ?? '',
      certificateType: json['certificateType']?.toString() ?? '',
      teacherName: teacherName,
      recipientName: recipientName,
      status: status,
      period: period == null ? null : CertificatePeriodModel.fromJson(period),
      previewImagePath: json['previewImagePath']?.toString() ?? '',
      pdfPath: json['pdfPath']?.toString() ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }

  static const placeholders = [
    TeacherCertificateModel(
      id: 'placeholder-1',
      certificateNumber: '',
      certificateType: 'ideal_teacher',
      teacherName: 'Teacher Name',
      recipientName: 'Teacher Name',
      status: 'draft',
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
      recipientName: 'Teacher Name',
      status: 'draft',
      period: null,
      previewImagePath: '',
      pdfPath: '',
      issuedAt: null,
    ),
  ];
}
