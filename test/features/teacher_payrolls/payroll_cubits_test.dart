import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/mock/teacher_payroll_mock_config.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_payroll_repo.dart';

void main() {
  setUp(() => kUseTeacherPayrollMockData = false);
  tearDown(() => kUseTeacherPayrollMockData = true);
  test('payment success emits paid payroll', () async {
    final cubit = PayrollPaymentCubit(FakeTeacherPayrollRepo());
    await cubit.pay(
      'p1',
      const PayrollPaymentRequest(receiptPath: 'receipt.jpg'),
    );
    expect((cubit.state as PayrollPaymentSuccess).payroll.status, 'paid');
  });
  for (final code in [
    'PAYROLL_ALREADY_FINALIZED',
    'PAYOUT_PROFILE_REQUIRED',
    'PAYOUT_METHOD_MISMATCH',
  ]) {
    test('payment exposes $code for UI recovery', () async {
      final repo = FakeTeacherPayrollRepo()
        ..payment = Left(Failure(message: code, code: code));
      final cubit = PayrollPaymentCubit(repo);
      await cubit.pay(
        'p1',
        const PayrollPaymentRequest(receiptPath: 'receipt.jpg'),
      );
      expect((cubit.state as PayrollPaymentFailure).code, code);
    });
  }
  test('draft deep link loads payroll then preview payout profile', () async {
    final repo = FakeTeacherPayrollRepo();
    final cubit = TeacherPayrollDetailsCubit(repo);
    await cubit.loadPayroll('p1');
    expect(repo.payrollLoads, 1);
    expect(repo.previewLoads, 1);
    expect((cubit.state as TeacherPayrollDetailsReady).profile, isNotNull);
  });

  test('paid immutable reloads payroll into read-only status', () async {
    final repo = FakeTeacherPayrollRepo();
    final cubit = TeacherPayrollDetailsCubit(repo);
    await cubit.loadPayroll('p1');
    repo.updateResult = Left(
      Failure(message: 'immutable', code: 'PAID_PAYROLL_IMMUTABLE'),
    );
    repo.reloadAfterUpdate = Right(
      TeacherPayrollModel.fromResponse({
        'data': {'id': 'p1', 'status': 'paid'},
      }),
    );
    await cubit.save(
      const SavePayrollRequest(
        currency: 'EGP',
        rates: [],
        bonus: 0,
        deduction: 0,
        adjustmentNote: '',
        notes: '',
      ),
    );
    expect((cubit.state as TeacherPayrollDetailsReady).payroll.status, 'paid');
  });
}
