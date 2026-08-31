import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_list_item_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_parsing.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_payment_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_session_details_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payroll_teacher_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/payout_profile_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/save_payroll_request.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_payroll_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_my_payrolls_model.dart';
import 'teacher_payroll_repo.dart';

class TeacherPayrollRepoImpl implements TeacherPayrollRepo {
  const TeacherPayrollRepoImpl(this.api);
  final ApiConsumer api;
  Map<String, dynamic> _period(String from, String to) => {
    'from': from,
    'to': to,
  };
  @override
  getMyPayrolls({String? status}) => repoGuard(() async {
    return TeacherMyPayrollsModel.fromResponse(
      await api.get(
        EndPoints.teacherMyPayrolls,
        queryParameter: status == null ? null : {'status': status},
        isProtected: true,
      ),
    );
  });
  @override
  getMyPayroll(String payrollId) => repoGuard(() async {
    return TeacherPayrollModel.fromResponse(
      await api.get(EndPoints.teacherMyPayroll(payrollId), isProtected: true),
    );
  });
  @override
  getMyPayoutProfile() => repoGuard(() async {
    final response = await api.get(
      EndPoints.teacherMyPayoutProfile,
      isProtected: true,
    );
    final root = payrollMap(response);
    if (!root.containsKey('data') || root['data'] == null) return null;
    return PayoutProfileModel.fromJson(root['data']);
  });
  @override
  saveMyPayoutProfile(PayoutProfileRequest request) => repoGuard(
    () async => PayoutProfileModel.fromJson(
      payrollData(
        await api.put(
          EndPoints.teacherMyPayoutProfile,
          data: request.toJson(),
          isProtected: true,
        ),
      ),
    ),
  );
  @override
  getPreviewList({
    required String from,
    required String to,
    String? teacherId,
  }) => repoGuard(() async {
    final response = await api.get(
      EndPoints.adminPayrollsPreview,
      queryParameter: {
        ..._period(from, to),
        if (teacherId?.isNotEmpty == true) 'teacherId': teacherId,
      },
      isProtected: true,
    );
    final data = payrollData(response);
    final values = data['teachers'] ?? data['items'] ?? data['data'];
    return payrollList(values).map(PayrollListItemModel.fromJson).toList();
  });
  @override
  getTeachers() => repoGuard(() async {
    final response = await api.get(
      EndPoints.users,
      queryParameter: {'role': 'teacher', 'page': 1},
      isProtected: true,
    );
    final values = payrollData(response);
    return payrollList(
      values['data'] ?? values['users'] ?? values,
    ).map(PayrollTeacherModel.fromJson).toList();
  });
  @override
  getTeacherPreview({
    required String teacherId,
    required String from,
    required String to,
  }) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.get(
        EndPoints.teacherPayrollPreview(teacherId),
        queryParameter: _period(from, to),
        isProtected: true,
      ),
    ),
  );
  @override
  getSessions({
    required String teacherId,
    required String curriculumId,
    required String from,
    required String to,
  }) => repoGuard(
    () async => PayrollSessionDetailsModel.fromResponse(
      await api.get(
        EndPoints.teacherPayrollSessions(teacherId, curriculumId),
        queryParameter: _period(from, to),
        isProtected: true,
      ),
    ),
  );
  @override
  create(SavePayrollRequest request) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.post(
        EndPoints.adminPayrolls,
        data: request.toJson(),
        isProtected: true,
      ),
    ),
  );
  @override
  getPayroll(String payrollId) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.get(EndPoints.adminPayroll(payrollId), isProtected: true),
    ),
  );
  @override
  update(String payrollId, SavePayrollRequest request) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.patch(
        EndPoints.adminPayroll(payrollId),
        data: request.toJson(),
        isProtected: true,
      ),
    ),
  );
  @override
  updatePayoutProfile(String teacherId, PayoutProfileRequest request) =>
      repoGuard(
        () async => PayoutProfileModel.fromJson(
          payrollData(
            await api.put(
              EndPoints.teacherPayoutProfile(teacherId),
              data: request.toJson(),
              isProtected: true,
            ),
          ),
        ),
      );
  @override
  pay(String payrollId, PayrollPaymentRequest request) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.post(
        EndPoints.payTeacherPayroll(payrollId),
        data: await request.toFormData(),
        isFormData: true,
        isProtected: true,
      ),
    ),
  );
}
