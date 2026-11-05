import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_supervisor/data/repos/admin_ideal_supervisor_repo.dart';
import 'package:bnan_app/features/ideal_supervisor/presentation/manager/admin_ideal_supervisor_cubit.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_cubit.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/repo/supervisor_assignment_repo.dart';
import 'package:bnan_app/features/teacher_application/data/models/teacher_request_model.dart';
import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/pending_teacher_requests_cubit/pending_teacher_requests_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignments_cubit/teacher_subject_assignments_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('teacher assignments request may finish after cubit close', () async {
    final repo = _TeacherAssignmentsRepo();
    final cubit = TeacherSubjectAssignmentsCubit(repo);
    final request = cubit.getTeacherTeachingAssignments();
    await cubit.close();
    repo.complete();
    await expectLater(request, completes);
  });

  test('pending teacher requests may finish after cubit close', () async {
    final repo = _TeacherRequestsRepo();
    final cubit = PendingTeacherRequestsCubit(repo);
    final request = cubit.getPendingTeacherRequests();
    await cubit.close();
    repo.complete();
    await expectLater(request, completes);
  });

  test('unassigned students request may finish after cubit close', () async {
    final repo = _StudentsRepo();
    final cubit = GetUnassignedStudentsCubit(repo);
    final request = cubit.getUnassignedStudents();
    await cubit.close();
    repo.complete();
    await expectLater(request, completes);
  });

  test('ideal supervisor load may finish after cubit close', () async {
    final repo = _SupervisorsRepo();
    final cubit = AdminIdealSupervisorCubit(repo, _IssueRepo());
    final request = cubit.load();
    await cubit.close();
    repo.complete();
    await expectLater(request, completes);
  });
}

Failure get _failure => Failure(message: 'late response');

class _TeacherAssignmentsRepo implements TeacherSubjectAssignmentRepo {
  final pending =
      Completer<Either<Failure, TeachingAssignmentsResponseModel>>();

  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments({
    String? keyword,
    String? subject,
  }) => pending.future;

  void complete() => pending.complete(Left(_failure));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TeacherRequestsRepo implements TeacherRequestsRepo {
  final pending = Completer<Either<Failure, TeacherRequestResponseModel>>();

  @override
  Future<Either<Failure, TeacherRequestResponseModel>>
  getPendingTeacherRequests() => pending.future;

  void complete() => pending.complete(Left(_failure));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StudentsRepo implements StudentClassroomAssignmentRepo {
  final pending = Completer<Either<Failure, List<UnassignedStudentModel>>>();

  @override
  Future<Either<Failure, List<UnassignedStudentModel>>>
  getUnassignedStudents() => pending.future;

  void complete() => pending.complete(Left(_failure));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SupervisorsRepo implements SupervisorAssignmentRepo {
  final pending = Completer<Either<Failure, GetSupervisorsResponseModel>>();

  @override
  Future<Either<Failure, GetSupervisorsResponseModel>> getSupervisors() =>
      pending.future;

  void complete() => pending.complete(Left(_failure));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _IssueRepo implements AdminIdealSupervisorRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
