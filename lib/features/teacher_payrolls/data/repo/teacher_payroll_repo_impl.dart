import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/dio_consumer.dart';
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
import 'package:bnan_app/features/teacher_payrolls/data/models/existing_statement_model.dart';
import 'package:bnan_app/features/teacher_payrolls/data/models/teacher_my_payrolls_model.dart';
import 'package:dartz/dartz.dart';
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
        EndPoints.teacherMyPayrollStatements,
        queryParameter: status == null ? null : {'status': status},
        isProtected: true,
      ),
    );
  });
  @override
  getMyPayroll(String payrollId) => repoGuard(() async {
    return TeacherPayrollModel.fromResponse(
      await api.get(
        EndPoints.teacherMyPayrollStatement(payrollId),
        isProtected: true,
      ),
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
    String? curriculumId,
  }) => repoGuard(() async {
    final endpoint = curriculumId?.isNotEmpty == true
        ? EndPoints.adminPayrollStatementPreview
        : EndPoints.adminPayrollsPreview;
    final response = await api.get(
      endpoint,
      queryParameter: {
        ..._period(from, to),
        if (teacherId?.isNotEmpty == true) 'teacherId': teacherId,
        if (curriculumId?.isNotEmpty == true) 'curriculumId': curriculumId,
      },
      isProtected: true,
    );
    final data = payrollData(response);
    final values = data['teachers'] ?? data['items'] ?? data['data'];
    return payrollList(values).map(PayrollListItemModel.fromJson).toList();
  });
  @override
  getStatementPreview({
    required String curriculumId,
    required String from,
    required String to,
  }) =>
      getPreviewList(from: from, to: to, curriculumId: curriculumId);
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
        EndPoints.adminPayrollStatements,
        data: request.toJson(),
        isProtected: true,
      ),
    ),
  );
  @override
  getPayroll(String payrollId) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.get(
        EndPoints.adminPayrollStatement(payrollId),
        isProtected: true,
      ),
    ),
  );
  @override
  update(String payrollId, SavePayrollRequest request) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.patch(
        EndPoints.adminPayrollStatement(payrollId),
        data: request.toPatchJson(),
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
        EndPoints.payAdminPayrollStatement(payrollId),
        data: await request.toFormData(),
        isFormData: true,
        isProtected: true,
      ),
    ),
  );
  @override
  sendStatement(String statementId) => repoGuard(
    () async => TeacherPayrollModel.fromResponse(
      await api.post(
        EndPoints.sendAdminPayrollStatement(statementId),
        isProtected: true,
      ),
    ),
  );
  @override
  deleteStatement(String statementId) => repoGuard(() async {
    await api.delete(
      EndPoints.adminPayrollStatement(statementId),
      isProtected: true,
    );
    return unit;
  });
  @override
  getStatements({String? teacherId, String? curriculumId}) =>
      repoGuard(() async {
        final response = await api.get(
          EndPoints.adminPayrollStatements,
          queryParameter: {
            if (teacherId?.isNotEmpty == true) 'teacherId': teacherId,
            if (curriculumId?.isNotEmpty == true) 'curriculumId': curriculumId,
          },
          isProtected: true,
        );
        final data = payrollData(response);
        final values =
            data['data'] ?? data['statements'] ?? data['items'] ?? data;
        return payrollList(values)
            .map(ExistingStatementModel.fromJson)
            .toList();
      });
  @override
  getReceiptBytes({required String statementId, bool isTeacher = false}) =>
      repoGuard(() async {
        final path = isTeacher
            ? EndPoints.teacherMyPayrollStatementReceipt(statementId)
            : EndPoints.adminPayrollStatementReceipt(statementId);
        final consumer = api;
        if (consumer is DioConsumer) {
          return await consumer.getBytes(path, isProtected: true);
        }
        final res = await api.get(path, isProtected: true);
        if (res is List<int>) return res;
        return const <int>[];
      });
}
