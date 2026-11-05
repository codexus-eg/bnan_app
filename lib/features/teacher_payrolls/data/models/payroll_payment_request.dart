import 'package:dio/dio.dart';

class PayrollPaymentRequest {
  const PayrollPaymentRequest({
    required this.receiptPath,
    this.paidAt,
    this.paymentReference = '',
    this.transactionReference = '',
    this.notes = '',
  });
  final String receiptPath, paymentReference, transactionReference, notes;
  final DateTime? paidAt;

  Future<FormData> toFormData() async {
    final ref = paymentReference.trim().isNotEmpty
        ? paymentReference.trim()
        : transactionReference.trim();
    final filename = receiptPath.split(RegExp(r'[/\\]')).last;
    final dateStr = paidAt != null
        ? '${paidAt!.year.toString().padLeft(4, '0')}-${paidAt!.month.toString().padLeft(2, '0')}-${paidAt!.day.toString().padLeft(2, '0')}'
        : null;
    return FormData.fromMap({
      'receipt': await MultipartFile.fromFile(receiptPath, filename: filename),
      if (dateStr != null) 'paidAt': dateStr,
      if (ref.isNotEmpty) 'paymentReference': ref,
      if (notes.trim().isNotEmpty) 'notes': notes.trim(),
    });
  }
}
