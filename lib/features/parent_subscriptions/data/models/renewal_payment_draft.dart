import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';

class RenewalPaymentDraft {
  const RenewalPaymentDraft({
    required this.paymentId,
    required this.checkoutUrl,
    required this.studentId,
    required this.subscriptionId,
    required this.ownerUserId,
    required this.idempotencyKey,
    required this.payloadFingerprint,
    required this.isParent,
    required this.createdAt,
    required this.registrationMode,
    this.provider = GulfPaymentProvider.tamara,
  });
  final String paymentId, checkoutUrl, studentId, subscriptionId, ownerUserId;
  final String idempotencyKey, payloadFingerprint, createdAt;
  final String registrationMode;
  final bool isParent;
  final GulfPaymentProvider provider;

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'checkoutUrl': checkoutUrl,
    'studentId': studentId,
    'subscriptionId': subscriptionId,
    'ownerUserId': ownerUserId,
    'idempotencyKey': idempotencyKey,
    'payloadFingerprint': payloadFingerprint,
    'isParent': isParent,
    'createdAt': createdAt,
    'registrationMode': registrationMode,
    'provider': provider.apiValue,
  };

  factory RenewalPaymentDraft.fromJson(Map<String, dynamic> json) =>
      RenewalPaymentDraft(
        paymentId: _text(json['paymentId']),
        checkoutUrl: _text(json['checkoutUrl']),
        studentId: _text(json['studentId']),
        subscriptionId: _text(json['subscriptionId']),
        ownerUserId: _text(json['ownerUserId']),
        idempotencyKey: _text(json['idempotencyKey']),
        payloadFingerprint: _text(json['payloadFingerprint']),
        isParent: json['isParent'] == true,
        createdAt: _text(json['createdAt']),
        registrationMode: _text(json['registrationMode']),
        provider: GulfPaymentProvider.fromApiValue(json['provider']),
      );
}

String _text(dynamic value) => value?.toString().trim() ?? '';
