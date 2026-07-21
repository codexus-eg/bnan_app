import 'certificate_academic_context_model.dart';
import 'certificate_period_model.dart';
import 'certificate_recipient_model.dart';
import 'certificate_recipient_snapshot_model.dart';
import 'certificate_subject_model.dart';
import 'certificate_user_model.dart';
import 'relation_parser.dart';

class MonthlyCertificateModel {
  const MonthlyCertificateModel({
    required this.id,
    required this.certificateNumber,
    required this.certificateType,
    required this.recipientType,
    required this.recipientId,
    required this.recipient,
    required this.templateKey,
    required this.signerName,
    required this.period,
    required this.academicContext,
    required this.recipientSnapshot,
    required this.subjects,
    required this.totalScore,
    required this.totalMaxScore,
    required this.percentage,
    required this.status,
    required this.previewImagePath,
    required this.createdById,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.issuedAt,
    required this.issuedById,
    required this.issuedBy,
    required this.pdfPath,
  });

  final String? id;
  final String? certificateNumber;
  final String? certificateType;
  final String? recipientType;
  final String? recipientId;
  final CertificateRecipientModel? recipient;
  final String? templateKey;
  final String? signerName;
  final CertificatePeriodModel? period;
  final CertificateAcademicContextModel? academicContext;
  final CertificateRecipientSnapshotModel? recipientSnapshot;
  final List<CertificateSubjectModel> subjects;
  final num? totalScore;
  final num? totalMaxScore;
  final num? percentage;
  final String? status;
  final String? previewImagePath;
  final String? createdById;
  final CertificateUserModel? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? issuedAt;
  final String? issuedById;
  final CertificateUserModel? issuedBy;
  final String? pdfPath;

  factory MonthlyCertificateModel.fromJson(Map<String, dynamic> json) {
    final recipientMap = RelationParser.mapOf(json['recipient']);
    final createdByMap = RelationParser.mapOf(json['createdBy']);
    final issuedByMap = RelationParser.mapOf(json['issuedBy']);
    final periodMap = RelationParser.mapOf(json['period']);
    final contextMap = RelationParser.mapOf(json['academicContext']);
    final snapshotMap = RelationParser.mapOf(json['recipientSnapshot']);
    final subjectsJson = json['subjects'];

    return MonthlyCertificateModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      certificateNumber: json['certificateNumber']?.toString(),
      certificateType: json['certificateType']?.toString(),
      recipientType: json['recipientType']?.toString(),
      recipientId: RelationParser.idOf(json['recipient']),
      recipient: recipientMap == null
          ? null
          : CertificateRecipientModel.fromJson(recipientMap),
      templateKey: json['templateKey']?.toString(),
      signerName: json['signerName']?.toString(),
      period: periodMap == null
          ? null
          : CertificatePeriodModel.fromJson(periodMap),
      academicContext: contextMap == null
          ? null
          : CertificateAcademicContextModel.fromJson(contextMap),
      recipientSnapshot: snapshotMap == null
          ? null
          : CertificateRecipientSnapshotModel.fromJson(snapshotMap),
      subjects: subjectsJson is List
          ? subjectsJson
                .whereType<Map>()
                .map(
                  (item) => CertificateSubjectModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      totalScore: num.tryParse(json['totalScore']?.toString() ?? ''),
      totalMaxScore: num.tryParse(json['totalMaxScore']?.toString() ?? ''),
      percentage: num.tryParse(json['percentage']?.toString() ?? ''),
      status: json['status']?.toString(),
      previewImagePath: json['previewImagePath']?.toString(),
      createdById: RelationParser.idOf(json['createdBy']),
      createdBy: createdByMap == null
          ? null
          : CertificateUserModel.fromJson(createdByMap),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
      issuedAt: DateTime.tryParse(json['issuedAt']?.toString() ?? ''),
      issuedById: RelationParser.idOf(json['issuedBy']),
      issuedBy: issuedByMap == null
          ? null
          : CertificateUserModel.fromJson(issuedByMap),
      pdfPath: json['pdfPath']?.toString(),
    );
  }
}
