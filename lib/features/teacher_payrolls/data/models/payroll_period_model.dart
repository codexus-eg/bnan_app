import 'payroll_parsing.dart';

class PayrollPeriodModel {
  const PayrollPeriodModel({required this.from, required this.to});
  final String from;
  final String to;

  factory PayrollPeriodModel.fromJson(Object? value) {
    final json = payrollMap(value);
    return PayrollPeriodModel(
      from: payrollString(json['from']),
      to: payrollString(json['to']),
    );
  }

  Map<String, dynamic> toJson() => {'from': from, 'to': to};
}
