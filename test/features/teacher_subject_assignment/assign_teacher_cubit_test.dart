import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const backendMessage =
      'يوجد معلم معيّن بالفعل لهذا الفصل الخليجي. يجب إلغاء تعيين المعلم '
      'الحالي أولاً قبل تعيين معلم جديد.';
  test('assign builds the request once and emits success', () async {
    final repo = _Repo();
    final cubit = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(cubit.close);
    final states = expectLater(
      cubit.stream,
      emitsInOrder([isA<AssignTeacherLoading>(), isA<AssignTeacherSuccess>()]),
    );

    await cubit.assignTeacher(
      teacherId: 'teacher-1',
      curriculumId: 'curriculum-1',
      gradeId: 'grade-1',
      classroomId: 'classroom-1',
      subjectId: 'subject-1',
      pricePerSession: 300,
    );
    await states;

    expect(repo.calls, 1);
    expect(repo.request?.toJson(), {
      'curriculum': 'curriculum-1',
      'grade': 'grade-1',
      'classroom': 'classroom-1',
      'subject': 'subject-1',
      'pricePerSession': 300,
    });
  });

  test('assign emits the repository failure message', () async {
    final repo = _Repo()..failure = Failure(message: backendMessage);
    final cubit = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(cubit.close);
    await cubit.assignTeacher(
      teacherId: 't',
      curriculumId: 'c',
      gradeId: 'g',
      classroomId: 'r',
      subjectId: 's',
      pricePerSession: 300,
    );
    expect(cubit.state, isA<AssignTeacherFailure>());
    expect((cubit.state as AssignTeacherFailure).errorMessage, backendMessage);
  });

  test('unassign calls the repo once and emits scoped success', () async {
    final repo = _Repo();
    final cubit = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(cubit.close);
    final states = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<UnassignTeacherLoading>(),
        isA<UnassignTeacherSuccess>(),
      ]),
    );

    await cubit.unassignTeacherFromClassroom(
      teacherId: 'teacher-1',
      classroomId: 'classroom-1',
    );
    await states;

    expect(repo.unassignCalls, 1);
    expect(repo.unassignTeacherId, 'teacher-1');
    expect(repo.unassignClassroomId, 'classroom-1');
  });

  test('unassign emits a scoped failure message', () async {
    final repo = _Repo()..unassignFailure = Failure(message: 'remove failed');
    final cubit = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(cubit.close);
    await cubit.unassignTeacherFromClassroom(
      teacherId: 'teacher-1',
      classroomId: 'classroom-1',
    );
    final state = cubit.state as UnassignTeacherFailure;
    expect(state.teacherId, 'teacher-1');
    expect(state.classroomId, 'classroom-1');
    expect(state.errorMessage, 'remove failed');
  });

  test('unassign ignores blank identifiers', () async {
    final repo = _Repo();
    final cubit = TeacherSubjectAssignmentActionsCubit(repo);
    addTearDown(cubit.close);
    await cubit.unassignTeacherFromClassroom(
      teacherId: ' ',
      classroomId: 'classroom-1',
    );
    expect(repo.unassignCalls, 0);
    expect(cubit.state, isA<TeacherSubjectAssignmentActionsInitial>());
  });
}

class _Repo implements TeacherSubjectAssignmentRepo {
  int calls = 0;
  Failure? failure;
  AssignTeacherRequestModel? request;
  int unassignCalls = 0;
  Failure? unassignFailure;
  String? unassignTeacherId;
  String? unassignClassroomId;

  @override
  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  }) async {
    calls++;
    this.request = request;
    if (failure != null) return Left(failure!);
    return const Right(
      AssignTeacherResponseModel(success: true, message: 'ok'),
    );
  }

  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments() async => throw UnimplementedError();
  @override
  Future<Either<Failure, AssignCurriculumsResponseModel>>
  assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  }) async => throw UnimplementedError();
  @override
  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) async {
    unassignCalls++;
    unassignTeacherId = teacherId;
    unassignClassroomId = classroomId;
    if (unassignFailure != null) return Left(unassignFailure!);
    return const Right(UnassignTeacherResponseModel(success: true));
  }
}
