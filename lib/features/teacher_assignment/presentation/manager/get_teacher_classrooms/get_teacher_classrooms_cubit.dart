import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherClassroomsCubit extends Cubit<GetTeacherClassroomsState> {
  GetTeacherClassroomsCubit(this.assignmentsRepo)
    : super(GetTeacherClassroomsInitial());

  final AssignmentsRepo assignmentsRepo;
  int _requestId = 0;

  Future<void> getMyClassrooms() async {
    if (isClosed) return;
    final requestId = ++_requestId;
    emit(GetTeacherClassroomsLoading());

    final result = await assignmentsRepo.getMyClassrooms();
    if (isClosed || requestId != _requestId) return;

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
