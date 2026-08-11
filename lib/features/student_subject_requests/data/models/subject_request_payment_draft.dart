class SubjectRequestPaymentDraft {
  const SubjectRequestPaymentDraft({
    required this.paymentId,
    required this.idempotencyKey,
    required this.subjectId,
    required this.packageId,
    this.checkoutUrl,
  });

  static const operationType = 'subject_request';
  final String paymentId;
  final String idempotencyKey;
  final String subjectId;
  final String packageId;
  final String? checkoutUrl;

  Map<String, dynamic> toJson() => {
    'operationType': operationType,
    'paymentId': paymentId,
    'idempotencyKey': idempotencyKey,
    'subjectId': subjectId,
    'packageId': packageId,
    'checkoutUrl': checkoutUrl,
  };

  factory SubjectRequestPaymentDraft.fromJson(Map<String, dynamic> json) =>
      SubjectRequestPaymentDraft(
        paymentId: (json['paymentId'] ?? '').toString(),
        idempotencyKey: (json['idempotencyKey'] ?? '').toString(),
        subjectId: (json['subjectId'] ?? '').toString(),
        packageId: (json['packageId'] ?? '').toString(),
        checkoutUrl: json['checkoutUrl']?.toString(),
      );
}
