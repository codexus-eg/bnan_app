import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('removes a deleted assignment from the current list', () async {
    final cubit = GetTeacherAssignmentsCubit(_AssignmentsRepo());
    await cubit.getAssignments(status: 'active');
    cubit.removeAssignment('a1');
    final state = cubit.state as GetTeacherAssignmentsSuccess;
    expect(state.assignments.assignments.map((item) => item.id), ['a2']);
    await cubit.close();
  });
}

class _AssignmentsRepo implements AssignmentsRepo {
  @override
  Future<Either<Failure, TeacherAssignmentsResponseModel>> getAssignments({
    String? status,
  }) async => Right(
    TeacherAssignmentsResponseModel.fromJson({
      'data': [
        {'id': 'a1', 'status': status},
        {'id': 'a2', 'status': status},
      ],
    }),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
