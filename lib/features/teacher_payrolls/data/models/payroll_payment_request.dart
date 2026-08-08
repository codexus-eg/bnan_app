import 'package:dio/dio.dart';

class PayrollPaymentRequest {
  const PayrollPaymentRequest({
    required this.receiptPath,
    this.paidAt,
    this.transactionReference = '',
    this.notes = '',
  });
  final String receiptPath, transactionReference, notes;
  final DateTime? paidAt;
  Future<FormData> toFormData() async => FormData.fromMap({
    'transferReceipt': await MultipartFile.fromFile(
      receiptPath,
      filename: receiptPath.split(RegExp(r'[/\\]')).last,
    ),
    if (paidAt != null) 'paidAt': paidAt!.toUtc().toIso8601String(),
    if (transactionReference.trim().isNotEmpty)
      'transactionReference': transactionReference.trim(),
    if (notes.trim().isNotEmpty) 'notes': notes.trim(),
  });
}
