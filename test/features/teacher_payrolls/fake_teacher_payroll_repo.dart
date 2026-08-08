import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_session_details_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/repo/teacher_payroll_repo.dart';
import 'package:dartz/dartz.dart';

class FakeTeacherPayrollRepo implements TeacherPayrollRepo {
  Either<Failure, TeacherPayrollModel> payment = Right(
    TeacherPayrollModel.fromResponse({
      'data': {'id': 'p1', 'status': 'paid'},
    }),
  );
  Either<Failure, TeacherPayrollModel> payroll = Right(
    TeacherPayrollModel.fromResponse({
      'data': {
        'id': 'p1',
        'status': 'draft',
        'teacher': {'id': 't1'},
        'period': {'from': '2026-08-01', 'to': '2026-08-31'},
      },
    }),
  );
  Either<Failure, TeacherPayrollModel>? updateResult;
  Either<Failure, TeacherPayrollModel>? reloadAfterUpdate;
  int payrollLoads = 0, previewLoads = 0;
  @override
  pay(String id, PayrollPaymentRequest request) async => payment;
  @override
  getPayroll(String id) async {
    payrollLoads++;
    return payroll;
  }

  @override
  getTeacherPreview({
    required String teacherId,
    required String from,
    required String to,
  }) async {
    previewLoads++;
    return Right(
      TeacherPayrollModel.fromResponse({
        'data': {
          'teacherId': teacherId,
          'period': {'from': from, 'to': to},
          'payoutProfile': {'method': 'instapay', 'accountHolderName': 'A'},
        },
      }),
    );
  }

  @override
  create(SavePayrollRequest request) async => payroll;
  @override
  update(String id, SavePayrollRequest request) async {
    final result = updateResult ?? payroll;
    if (reloadAfterUpdate != null) payroll = reloadAfterUpdate!;
    return result;
  }

  @override
  getPreviewList({
    required String from,
    required String to,
    String? teacherId,
  }) async => const Right(<PayrollListItemModel>[]);
  @override
  getTeachers() async => const Right(<PayrollTeacherModel>[]);
  @override
  getSessions({
    required String teacherId,
    required String curriculumId,
    required String from,
    required String to,
  }) async => const Right(
    PayrollSessionDetailsModel(
      sessions: [],
      sessionsCount: 0,
      totalMinutes: 0,
      displayDuration: '',
    ),
  );
  @override
  updatePayoutProfile(String id, PayoutProfileRequest request) async =>
      Right(PayoutProfileModel.fromJson(request.toJson()));
}
