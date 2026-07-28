import 'package:dio/dio.dart';

class ConfirmRegistrationPaymentRequestModel {
  const ConfirmRegistrationPaymentRequestModel({
    required this.amount,
    required this.method,
    this.receiptImagePath,
    this.notes,
  });

  final num amount;
  final String method;
  final String? receiptImagePath;
  final String? notes;

  Future<FormData> toFormData() async {
    final receiptPath = receiptImagePath?.trim();
    final trimmedNotes = notes?.trim();

    return FormData.fromMap({
      'amount': amount,
      'method': method.trim(),
      if (trimmedNotes != null && trimmedNotes.isNotEmpty)
        'notes': trimmedNotes,
      if (receiptPath != null && receiptPath.isNotEmpty)
        'receiptImage': await MultipartFile.fromFile(
          receiptPath,
          filename: receiptPath.split(RegExp(r'[/\\]')).last,
        ),
    });
  }
}
