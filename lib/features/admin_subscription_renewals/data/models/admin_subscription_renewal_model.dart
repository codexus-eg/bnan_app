import 'admin_renewal_status.dart';

class AdminSubscriptionRenewalModel {
  const AdminSubscriptionRenewalModel({
    required this.id,
    required this.studentName,
    required this.studentEmail,
    required this.curriculum,
    required this.grade,
    required this.packageName,
    required this.packageType,
    required this.currency,
    required this.method,
    required this.status,
    this.subject,
    this.requestedBy,
    this.amount,
    this.receiptImage,
    this.referenceNumber,
    this.rejectionReason,
    this.createdAt,
  });

  final String id, studentName, studentEmail, curriculum, grade;
  final String packageName, packageType, currency, method;
  final AdminRenewalStatus status;
  final String? subject, requestedBy, receiptImage, referenceNumber;
  final String? rejectionReason;
  final num? amount;
  final DateTime? createdAt;

  factory AdminSubscriptionRenewalModel.fromJson(Map<String, dynamic> json) {
    final student = _map(json['student']);
    final user = _map(student['user']);
    final package = _map(json['package']);
    return AdminSubscriptionRenewalModel(
      id: _text(json['id'] ?? json['_id']),
      studentName: _text(user['fullName'] ?? student['fullName']),
      studentEmail: _text(user['email'] ?? student['email']),
      curriculum: _name(student['curriculum']),
      grade: _name(student['grade']),
      packageName: _text(package['name']),
      packageType: _text(package['type']),
      subject: _nullableName(json['subject']),
      requestedBy: _nullableName(json['requestedBy']),
      amount: _number(json['amount'] ?? package['price']),
      currency: _text(package['currency'] ?? json['currency']),
      receiptImage: _nullable(json['receiptImage']),
      method: _text(json['method']),
      referenceNumber: _nullable(json['referenceNumber']),
      status: AdminRenewalStatus.parse(json['status']),
      rejectionReason: _nullable(json['rejectionReason']),
      createdAt: DateTime.tryParse(_text(json['createdAt'])),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};
String _text(Object? value) => value?.toString().trim() ?? '';
String _name(Object? value) =>
    value is Map ? _text(value['name'] ?? value['fullName']) : _text(value);
String? _nullable(Object? value) => _text(value).isEmpty ? null : _text(value);
String? _nullableName(Object? value) {
  final text = _name(value);
  return text.isEmpty ? null : text;
}

num? _number(Object? value) =>
    value is num ? value : num.tryParse(_text(value));
