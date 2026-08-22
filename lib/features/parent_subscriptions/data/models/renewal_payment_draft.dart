class RenewalPaymentDraft {
  const RenewalPaymentDraft({
    required this.paymentId,
    required this.checkoutUrl,
    required this.studentId,
    required this.ownerUserId,
    required this.idempotencyKey,
    required this.payloadFingerprint,
    required this.isParent,
    required this.createdAt,
    required this.registrationMode,
  });
  final String paymentId, checkoutUrl, studentId, ownerUserId;
  final String idempotencyKey, payloadFingerprint, createdAt;
  final String registrationMode;
  final bool isParent;

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'checkoutUrl': checkoutUrl,
    'studentId': studentId,
    'ownerUserId': ownerUserId,
    'idempotencyKey': idempotencyKey,
    'payloadFingerprint': payloadFingerprint,
    'isParent': isParent,
    'createdAt': createdAt,
    'registrationMode': registrationMode,
  };

  factory RenewalPaymentDraft.fromJson(Map<String, dynamic> json) =>
      RenewalPaymentDraft(
        paymentId: _text(json['paymentId']),
        checkoutUrl: _text(json['checkoutUrl']),
        studentId: _text(json['studentId']),
        ownerUserId: _text(json['ownerUserId']),
        idempotencyKey: _text(json['idempotencyKey']),
        payloadFingerprint: _text(json['payloadFingerprint']),
        isParent: json['isParent'] == true,
        createdAt: _text(json['createdAt']),
        registrationMode: _text(json['registrationMode']),
      );
}

String _text(dynamic value) => value?.toString().trim() ?? '';
