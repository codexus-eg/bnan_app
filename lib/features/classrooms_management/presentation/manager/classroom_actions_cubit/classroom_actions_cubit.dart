import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_actions_cubit/classroom_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomActionsCubit extends Cubit<ClassroomActionsState> {
  ClassroomActionsCubit(this.classroomsRepo)
      : super(ClassroomActionsInitial());

  final ClassroomsRepo classroomsRepo;

  Future<void> createClassroom(ClassroomRequestModel model) async {
    emit(CreateClassroomLoading());

    final result = await classroomsRepo.createClassroom(model);
    result.fold(
      (failure) => emit(CreateClassroomFailure(failure.message)),
      (_) => emit(CreateClassroomSuccess()),
    );
  }

  Future<void> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  ) async {
    emit(UpdateClassroomLoading());

    final result = await classroomsRepo.updateClassroom(classroomId, model);
    result.fold(
      (failure) => emit(UpdateClassroomFailure(failure.message)),
      (_) => emit(UpdateClassroomSuccess()),
    );
  }
}
