import 'certificate_period_model.dart';
import 'relation_parser.dart';

class MonthlyCertificateSummaryModel {
  const MonthlyCertificateSummaryModel({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.studentName,
    required this.gradeName,
    required this.period,
    required this.status,
    required this.previewImagePath,
    required this.pdfPath,
    required this.createdAt,
    required this.issuedAt,
  });

  final String? id;
  final String? certificateNumber;
  final String? certificateType;
  final String? studentName;
  final String? gradeName;
  final CertificatePeriodModel? period;
  final String? status;
  final String? previewImagePath;
  final String? pdfPath;
  final DateTime? createdAt;
  final DateTime? issuedAt;

  bool get isIssued => status?.trim().toLowerCase() == 'issued';

  factory MonthlyCertificateSummaryModel.fromJson(Map<String, dynamic> json) {
    final periodMap = RelationParser.mapOf(json['period']);

    return MonthlyCertificateSummaryModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      certificateNumber: json['certificateNumber']?.toString(),
      certificateType: json['certificateType']?.toString(),
      studentName: json['studentName']?.toString(),
      gradeName: json['gradeName']?.toString(),
      period: periodMap == null
          ? null
          : CertificatePeriodModel.fromJson(periodMap),
      status: json['status']?.toString(),
      previewImagePath: json['previewImagePath']?.toString(),
      pdfPath: json['pdfPath']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
    );
  }
  static const placeholderCertificates = [
    MonthlyCertificateSummaryModel(
      id: 'placeholder-1',
      certificateNumber: 'CERT-001',
      certificateType: 'monthly',
      studentName: 'اسم الطالب',
      gradeName: 'الصف الدراسي',
      period: null,
      status: 'issued',
      previewImagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
      pdfPath: '',
      createdAt: null,
      issuedAt: null,
    ),
    MonthlyCertificateSummaryModel(
      id: 'placeholder-2',
      certificateNumber: 'CERT-002',
      certificateType: 'monthly',
      studentName: 'اسم الطالب',
      gradeName: 'الصف الدراسي',
      period: null,
      status: 'issued',
      previewImagePath: 'assets/images/teacher_home/IMG-20260603-WA0030 2.png',
      pdfPath: '',
      createdAt: null,
      issuedAt: null,
    ),
  ];
}
