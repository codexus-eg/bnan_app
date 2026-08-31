import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_method.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/details/teacher_payroll_details_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payment/payroll_payment_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/payout/teacher_payout_profile_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payroll_details/teacher_payroll_report_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payroll_details/teacher_payroll_report_state.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_cubit.dart';
import 'package:bnan_app/features/teacher_payrolls/presentation/manager/teacher_payrolls/teacher_my_payrolls_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'fake_teacher_payroll_repo.dart';

void main() {
  setUpAll(() => S.load(const Locale('en')));

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
  test('teacher payroll report exposes 404 as not found', () async {
    final repo = FakeTeacherPayrollRepo()
      ..payroll = Left(Failure(message: 'missing', statusCode: 404));
    final cubit = TeacherPayrollReportCubit(repo);
    await cubit.load('missing');
    final state = cubit.state as TeacherPayrollReportFailure;
    expect(state.notFound, isTrue);
  });

  test('teacher payroll report success returns read-only model', () async {
    final cubit = TeacherPayrollReportCubit(FakeTeacherPayrollRepo());
    await cubit.load('p1');
    expect((cubit.state as TeacherPayrollReportReady).payroll.id, 'p1');
  });
  test('teacher payroll empty API emits ready empty state', () async {
    final repo = FakeTeacherPayrollRepo();
    final cubit = TeacherMyPayrollsCubit(repo);
    await cubit.load();
    final state = cubit.state as TeacherMyPayrollsReady;
    expect(state.data.payrolls, isEmpty);
    expect(repo.myPayrollListLoads, 1);
  });
  test('teacher payroll API failure emits failure without fallback', () async {
    final repo = FakeTeacherPayrollRepo()
      ..myPayrolls = Left(Failure(message: 'network failure'));
    final cubit = TeacherMyPayrollsCubit(repo);
    await cubit.load();
    expect(cubit.state, isA<TeacherMyPayrollsFailure>());
  });
  test('my payout profile exposes empty API state', () async {
    final cubit = TeacherPayoutProfileCubit(FakeTeacherPayrollRepo());
    await cubit.loadMine();
    expect(cubit.state, isA<TeacherPayoutProfileEmpty>());
  });
  test('my payout profile maps backend error codes', () async {
    final repo = FakeTeacherPayrollRepo()
      ..myPayoutSave = Left(
        Failure(message: 'raw', code: 'PAYOUT_BANK_DATA_REQUIRED'),
      );
    final cubit = TeacherPayoutProfileCubit(repo);
    await cubit.saveMine(
      const PayoutProfileRequest(
        method: PayoutMethod.bankAccount,
        accountHolderName: 'A',
        bankName: 'CIB',
        accountNumber: '1',
      ),
    );
    final state = cubit.state as TeacherPayoutProfileFailure;
    expect(state.message, S.current.payoutBankRequired);
  });
}
