enum GulfPaymentProvider {
  tamara,
  paymob;

  String get apiValue => name;

  bool get supportsReconcile => this == tamara;

  static GulfPaymentProvider fromApiValue(dynamic value) {
    final normalized = value?.toString().trim().toLowerCase();
    return GulfPaymentProvider.values.firstWhere(
      (provider) => provider.apiValue == normalized,
      orElse: () => GulfPaymentProvider.tamara,
    );
  }
}
