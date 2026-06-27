import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherClassroomsCubit extends Cubit<GetTeacherClassroomsState> {
  GetTeacherClassroomsCubit(this.assignmentsRepo)
    : super(GetTeacherClassroomsInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> getMyClassrooms() async {
    emit(GetTeacherClassroomsLoading());

    final result = await assignmentsRepo.getMyClassrooms();

    result.fold(
      (failure) {
        emit(GetTeacherClassroomsFailure(errorMessage: failure.message));
      },
      (classrooms) {
        emit(GetTeacherClassroomsSuccess(classrooms: classrooms));
      },
    );
  }
}