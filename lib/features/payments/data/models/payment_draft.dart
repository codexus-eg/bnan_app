import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';

enum PaymentDraftPurpose { registration, addChild }

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
    this.provider = GulfPaymentProvider.tamara,
    this.purpose = PaymentDraftPurpose.registration,
    this.ownerUserId = '',
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
  final GulfPaymentProvider provider;
  final PaymentDraftPurpose purpose;
  final String payloadFingerprint;
  final String ownerUserId;

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
    provider: GulfPaymentProvider.fromApiValue(json['provider']),
    purpose: _purpose(json),
    payloadFingerprint: json['payloadFingerprint']?.toString() ?? '',
    ownerUserId: json['ownerUserId']?.toString() ?? '',
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
    'provider': provider.apiValue,
    'purpose': purpose.name,
    'ownerUserId': ownerUserId,
    'payloadFingerprint': payloadFingerprint,
  };

  static String? _optionalText(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static PaymentDraftPurpose _purpose(Map<String, dynamic> json) {
    final value = json['purpose']?.toString().trim();
    for (final purpose in PaymentDraftPurpose.values) {
      if (purpose.name == value) return purpose;
    }
    final fingerprint = json['payloadFingerprint']?.toString() ?? '';
    return fingerprint.startsWith('parent_add_child:')
        ? PaymentDraftPurpose.addChild
        : PaymentDraftPurpose.registration;
  }
}
