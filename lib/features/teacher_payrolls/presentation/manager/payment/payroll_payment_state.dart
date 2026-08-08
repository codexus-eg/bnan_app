import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';

sealed class PayrollPaymentState {
  const PayrollPaymentState();
}

class PayrollPaymentInitial extends PayrollPaymentState {
  const PayrollPaymentInitial();
}

class PayrollPaymentLoading extends PayrollPaymentState {
  const PayrollPaymentLoading();
}

class PayrollPaymentSuccess extends PayrollPaymentState {
  const PayrollPaymentSuccess(this.payroll);
  final TeacherPayrollModel payroll;
}

class PayrollPaymentFailure extends PayrollPaymentState {
  const PayrollPaymentFailure(this.message, this.code);
  final String message;
  final String? code;
}
