import 'package:bnan_app/features/payments/data/models/payment_amount_summary.dart';

class DiscountPreviewState {
  const DiscountPreviewState({
    this.isLoading = false,
    this.summary,
    this.fingerprint,
    this.error,
  });

  final bool isLoading;
  final PaymentAmountSummary? summary;
  final String? fingerprint;
  final String? error;

  bool matches(String value) =>
      !isLoading && summary?.canDisplay == true && fingerprint == value;
}
