import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payroll_payment_state.dart';

class PayrollPaymentCubit extends Cubit<PayrollPaymentState> {
  PayrollPaymentCubit(this.repo) : super(const PayrollPaymentInitial());
  final TeacherPayrollRepo repo;
  bool _paying = false;
  Future<void> pay(String id, PayrollPaymentRequest request) async {
    if (_paying) return;
    _paying = true;
    emit(const PayrollPaymentLoading());
    final result = await repo.pay(id, request);
    _paying = false;
    result.fold(
      (f) => emit(PayrollPaymentFailure(f.message, f.code)),
      (p) => emit(PayrollPaymentSuccess(p)),
    );
  }
}
