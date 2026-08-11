import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_session_details_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_my_payrolls_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherPayrollRepo {
  Future<Either<Failure, TeacherMyPayrollsModel>> getMyPayrolls({
    String? status,
  });
  Future<Either<Failure, TeacherPayrollModel>> getMyPayroll(String payrollId);
  Future<Either<Failure, PayoutProfileModel?>> getMyPayoutProfile();
  Future<Either<Failure, List<PayrollListItemModel>>> getPreviewList({
    required String from,
    required String to,
    String? teacherId,
  });
  Future<Either<Failure, List<PayrollTeacherModel>>> getTeachers();
  Future<Either<Failure, TeacherPayrollModel>> getTeacherPreview({
    required String teacherId,
    required String from,
    required String to,
  });
  Future<Either<Failure, PayrollSessionDetailsModel>> getSessions({
    required String teacherId,
    required String curriculumId,
    required String from,
    required String to,
  });
  Future<Either<Failure, TeacherPayrollModel>> create(
    SavePayrollRequest request,
  );
  Future<Either<Failure, TeacherPayrollModel>> getPayroll(String payrollId);
  Future<Either<Failure, TeacherPayrollModel>> update(
    String payrollId,
    SavePayrollRequest request,
  );
  Future<Either<Failure, PayoutProfileModel>> updatePayoutProfile(
    String teacherId,
    PayoutProfileRequest request,
  );
  Future<Either<Failure, TeacherPayrollModel>> pay(
    String payrollId,
    PayrollPaymentRequest request,
  );
}
