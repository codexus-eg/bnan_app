import 'package:dio/dio.dart';

class AdminSubjectRequestApproval {
  const AdminSubjectRequestApproval({
    required this.receiptImagePath,
    this.amount,
    this.method,
    this.referenceNumber,
    this.paymentNotes,
  });

  static const allowedMethods = {
    'cash',
    'bank_transfer',
    'instapay',
    'wallet',
    'other',
  };
  final String receiptImagePath;
  final num? amount;
  final String? method;
  final String? referenceNumber;
  final String? paymentNotes;

  Future<FormData> toFormData() async {
    final selectedMethod = _optional(method);
    if (selectedMethod != null && !allowedMethods.contains(selectedMethod)) {
      throw ArgumentError.value(method, 'method', 'Unsupported payment method');
    }
    final path = receiptImagePath.trim();
    if (path.isEmpty) throw ArgumentError('receiptImage is required');
    return FormData.fromMap({
      'receiptImage': await MultipartFile.fromFile(
        path,
        filename: path.split(RegExp(r'[/\\]')).last,
      ),
      if (amount != null) 'amount': amount,
      if (selectedMethod != null) 'method': selectedMethod,
      if (_optional(referenceNumber) case final value?)
        'referenceNumber': value,
      if (_optional(paymentNotes) case final value?) 'paymentNotes': value,
    });
  }
}

String? _optional(String? value) {
  final text = value?.trim();
  return text == null || text.isEmpty ? null : text;
}
