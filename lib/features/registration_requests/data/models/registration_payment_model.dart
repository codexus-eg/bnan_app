import 'registration_json_parsing.dart';

class RegistrationPaymentModel {
  const RegistrationPaymentModel({
    required this.id,
    required this.status,
    required this.amount,
    required this.currency,
    required this.method,
    required this.referenceNumber,
    required this.receiptImage,
    required this.confirmedAt,
    required this.notes,
  });

  final String? id;
  final String status;
  final num? amount;
  final String currency;
  final String? method;
  final String? referenceNumber;
  final String? receiptImage;
  final DateTime? confirmedAt;
  final String? notes;

  factory RegistrationPaymentModel.fromJson(Map<String, dynamic> json) {
    return RegistrationPaymentModel(
      id: nullableRegistrationString(json['id'] ?? json['_id']),
      status: registrationString(json['status']),
      amount: registrationNum(json['amount']),
      currency: registrationString(json['currency']),
      method: nullableRegistrationString(json['method']),
      referenceNumber: nullableRegistrationString(json['referenceNumber']),
      receiptImage: nullableRegistrationString(json['receiptImage']),
      confirmedAt: parseRegistrationDate(json['confirmedAt']),
      notes: nullableRegistrationString(json['notes']),
    );
  }
}
