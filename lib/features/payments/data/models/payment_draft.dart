import 'package:bnan_app/features/payments/data/models/payment_status.dart';

class PaymentDraft {
  const PaymentDraft({
    required this.paymentId,
    required this.idempotencyKey,
    required this.packageId,
    required this.curriculumId,
    required this.gradeId,
    required this.subjectIds,
    required this.studentEmail,
    required this.paymentStartedAt,
    required this.lastKnownStatus,
    this.payloadFingerprint = '',
    this.checkoutUrl,
    this.checkoutOpenedAt,
  });

  final String paymentId;
  final String? checkoutUrl;
  final DateTime? checkoutOpenedAt;
  final String idempotencyKey;
  final String packageId;
  final String curriculumId;
  final String gradeId;
  final List<String> subjectIds;
  final String studentEmail;
  final DateTime paymentStartedAt;
  final PaymentStatus lastKnownStatus;
  final String payloadFingerprint;

  factory PaymentDraft.fromJson(Map<String, dynamic> json) => PaymentDraft(
    paymentId: json['paymentId']?.toString() ?? '',
    checkoutUrl: _optionalText(json['checkoutUrl']),
    checkoutOpenedAt: DateTime.tryParse(
      _optionalText(json['checkoutOpenedAt']) ?? '',
    ),
    idempotencyKey: json['idempotencyKey']?.toString() ?? '',
    packageId: json['packageId']?.toString() ?? '',
    curriculumId: json['curriculumId']?.toString() ?? '',
    gradeId: json['gradeId']?.toString() ?? '',
    subjectIds: (json['subjectIds'] as List? ?? [])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(),
    studentEmail: json['studentEmail']?.toString() ?? '',
    paymentStartedAt:
        DateTime.tryParse(json['paymentStartedAt']?.toString() ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    lastKnownStatus: PaymentStatus.fromValue(json['lastKnownStatus']),
    payloadFingerprint: json['payloadFingerprint']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'checkoutUrl': checkoutUrl,
    'checkoutOpenedAt': checkoutOpenedAt?.toIso8601String(),
    'idempotencyKey': idempotencyKey,
    'packageId': packageId,
    'curriculumId': curriculumId,
    'gradeId': gradeId,
    'subjectIds': subjectIds,
    'studentEmail': studentEmail,
    'paymentStartedAt': paymentStartedAt.toIso8601String(),
    'lastKnownStatus': lastKnownStatus.name,
    'payloadFingerprint': payloadFingerprint,
  };

  static String? _optionalText(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }
}
