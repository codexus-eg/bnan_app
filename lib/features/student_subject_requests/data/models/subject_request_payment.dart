class SubjectRequestPayment {
  const SubjectRequestPayment({
    required this.paymentId,
    required this.status,
    this.checkoutUrl,
    this.subjectRequestId,
  });

  final String paymentId;
  final SubjectRequestPaymentStatus status;
  final String? checkoutUrl;
  final String? subjectRequestId;

  factory SubjectRequestPayment.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : json;
    return SubjectRequestPayment(
      paymentId: (data['paymentId'] ?? '').toString(),
      status: SubjectRequestPaymentStatus.fromValue(data['status']),
      checkoutUrl: _text(data['checkoutUrl']),
      subjectRequestId: _text(data['subjectRequestId']),
    );
  }
}

enum SubjectRequestPaymentStatus {
  pending,
  authorized,
  captured,
  completed,
  failed,
  cancelled,
  expired,
  refunded,
  unknown;

  factory SubjectRequestPaymentStatus.fromValue(dynamic value) =>
      values.firstWhere(
        (item) => item.name == value?.toString().trim().toLowerCase(),
        orElse: () => unknown,
      );

  bool get isProcessing =>
      this == pending || this == authorized || this == captured;
  bool get allowsNewAttempt =>
      this == failed || this == cancelled || this == expired;
  bool get isTerminal => !isProcessing && this != unknown;
}

String? _text(dynamic value) =>
    value?.toString().trim().isEmpty == false ? value.toString().trim() : null;
