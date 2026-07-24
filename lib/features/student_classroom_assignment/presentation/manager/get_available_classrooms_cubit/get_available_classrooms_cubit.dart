import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/features/student_classroom_assignment/presentation/manager/get_available_classrooms_cubit/get_available_classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAvailableClassroomsCubit
    extends Cubit<GetAvailableClassroomsState> {
  GetAvailableClassroomsCubit(this.repo)
      : super(const GetAvailableClassroomsInitial());

  final StudentClassroomAssignmentRepo repo;

  Future<void> getAvailableClassrooms(String studentId) async {
    emit(const GetAvailableClassroomsLoading());

    final result = await repo.getAvailableClassrooms(studentId);

    result.fold(
      (failure) => emit(
        GetAvailableClassroomsFailure(failure.message),
      ),
      (response) => emit(
        GetAvailableClassroomsSuccess(response),
      ),
    );
  }

  void reset() {
    emit(const GetAvailableClassroomsInitial());
  }
}