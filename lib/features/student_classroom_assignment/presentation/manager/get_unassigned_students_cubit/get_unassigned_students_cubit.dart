import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_unassigned_students_cubit/get_unassigned_students_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUnassignedStudentsCubit
    extends Cubit<GetUnassignedStudentsState> {
  GetUnassignedStudentsCubit(this.repo)
      : super(const GetUnassignedStudentsInitial());

  final StudentClassroomAssignmentRepo repo;

  Future<void> getUnassignedStudents() async {
    emit(const GetUnassignedStudentsLoading());

    final result = await repo.getUnassignedStudents();

    result.fold(
      (failure) => emit(
        GetUnassignedStudentsFailure(failure.message),
      ),
      (students) => emit(
        GetUnassignedStudentsSuccess(students),
      ),
    );
  }
}