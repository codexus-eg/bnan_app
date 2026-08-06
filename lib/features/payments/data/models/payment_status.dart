enum PaymentStatus {
  pending,
  completed,
  failed,
  cancelled,
  expired,
  refunded,
  unknown;

  factory PaymentStatus.fromValue(dynamic value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.name == value?.toString().trim().toLowerCase(),
      orElse: () => PaymentStatus.unknown,
    );
  }

  bool get isTerminal => switch (this) {
    completed || failed || cancelled || expired || refunded => true,
    pending || unknown => false,
  };
}
