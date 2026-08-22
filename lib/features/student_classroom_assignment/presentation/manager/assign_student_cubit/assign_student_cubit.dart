import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/assign_student_cubit/assign_student_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignStudentCubit extends Cubit<AssignStudentState> {
  AssignStudentCubit(this.repo) : super(const AssignStudentInitial());

  final StudentClassroomAssignmentRepo repo;

  Future<void> assignStudent({
    required String studentId,
    required String classroomId,
  }) async {
    if (isClosed) return;
    emit(const AssignStudentLoading());

    final result = await repo.assignStudent(
      studentId: studentId,
      classroomId: classroomId,
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(AssignStudentFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(AssignStudentSuccess(response));
      },
    );
  }

  void reset() {
    if (isClosed) return;
    emit(const AssignStudentInitial());
  }
}
