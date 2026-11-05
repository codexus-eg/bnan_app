import 'payroll_parsing.dart';
import 'payout_profile_model.dart';

class PayrollPaymentModel {
  const PayrollPaymentModel({
    required this.method,
    required this.paidAt,
    required this.transactionReference,
    required this.notes,
    required this.receiptUrl,
    this.hasReceipt = false,
    this.destinationSnapshot,
  });
  final String method, paidAt, transactionReference, notes, receiptUrl;
  final bool hasReceipt;
  final PayoutProfileModel? destinationSnapshot;

  factory PayrollPaymentModel.fromJson(Object? value) {
    final json = payrollMap(value);
    final snapshot = json['destinationSnapshot'];
    final receiptUrl = payrollString(
      json['receiptUrl'] ??
          json['transferReceiptUrl'] ??
          json['transferReceipt'],
    );
    final hasReceipt = json['hasReceipt'] is bool
        ? json['hasReceipt'] as bool
        : (json['hasReceipt'] == 'true' || receiptUrl.isNotEmpty);
    return PayrollPaymentModel(
      method: payrollString(json['method'] ?? json['paymentMethod']),
      paidAt: payrollString(json['paidAt']),
      transactionReference: payrollString(json['transactionReference']),
      notes: payrollString(json['notes']),
      receiptUrl: receiptUrl,
      hasReceipt: hasReceipt,
      destinationSnapshot: snapshot is Map
          ? PayoutProfileModel.fromJson(snapshot)
          : null,
    );
  }
}
