import 'payroll_parsing.dart';
import 'payout_profile_model.dart';

class PayrollPaymentModel {
  const PayrollPaymentModel({
    required this.method,
    required this.paidAt,
    required this.transactionReference,
    required this.notes,
    required this.receiptUrl,
    this.destinationSnapshot,
  });
  final String method, paidAt, transactionReference, notes, receiptUrl;
  final PayoutProfileModel? destinationSnapshot;

  factory PayrollPaymentModel.fromJson(Object? value) {
    final json = payrollMap(value);
    final snapshot = json['destinationSnapshot'];
    return PayrollPaymentModel(
      method: payrollString(json['method'] ?? json['paymentMethod']),
      paidAt: payrollString(json['paidAt']),
      transactionReference: payrollString(json['transactionReference']),
      notes: payrollString(json['notes']),
      receiptUrl: payrollString(
        json['receiptUrl'] ??
            json['transferReceiptUrl'] ??
            json['transferReceipt'],
      ),
      destinationSnapshot: snapshot is Map
          ? PayoutProfileModel.fromJson(snapshot)
          : null,
    );
  }
}
