import 'payroll_parsing.dart';

class PayrollTeacherModel {
  const PayrollTeacherModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });
  final String id, fullName, email, phone;

  factory PayrollTeacherModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollTeacherModel(
      id: payrollString(json['teacherId'] ?? json['_id'] ?? json['id']),
      fullName: payrollString(json['fullName'] ?? json['name']),
      email: payrollString(json['email']),
      phone: payrollString(json['phone'] ?? json['phoneNumber']),
    );
  }
}
