import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';

class SubjectRequestPaymentDraft {
  const SubjectRequestPaymentDraft({
    required this.paymentId,
    required this.idempotencyKey,
    required this.subjectId,
    required this.packageId,
    required this.payloadFingerprint,
    required this.ownerUserId,
    this.provider = GulfPaymentProvider.tamara,
    this.checkoutUrl,
  });

  static const operationType = 'subject_request';
  final String paymentId;
  final String idempotencyKey;
  final String subjectId;
  final String packageId;
  final String payloadFingerprint;
  final String ownerUserId;
  final GulfPaymentProvider provider;
  final String? checkoutUrl;

  Map<String, dynamic> toJson() => {
    'operationType': operationType,
    'paymentId': paymentId,
    'idempotencyKey': idempotencyKey,
    'subjectId': subjectId,
    'packageId': packageId,
    'payloadFingerprint': payloadFingerprint,
    'ownerUserId': ownerUserId,
    'provider': provider.apiValue,
    'checkoutUrl': checkoutUrl,
  };

  factory SubjectRequestPaymentDraft.fromJson(Map<String, dynamic> json) =>
      SubjectRequestPaymentDraft(
        paymentId: (json['paymentId'] ?? '').toString(),
        idempotencyKey: (json['idempotencyKey'] ?? '').toString(),
        subjectId: (json['subjectId'] ?? '').toString(),
        packageId: (json['packageId'] ?? '').toString(),
        payloadFingerprint: (json['payloadFingerprint'] ?? '').toString(),
        ownerUserId: (json['ownerUserId'] ?? '').toString(),
        provider: GulfPaymentProvider.fromApiValue(json['provider']),
        checkoutUrl: json['checkoutUrl']?.toString(),
      );
}
