import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomDetailsCubit extends Cubit<ClassroomDetailsState> {
  ClassroomDetailsCubit(this.classroomsRepo)
      : super(ClassroomDetailsInitial());

  final ClassroomsRepo classroomsRepo;

  Future<void> getClassroomDetails(String classroomId) async {
    emit(ClassroomDetailsLoading());

    final result = await classroomsRepo.getClassroomDetails(classroomId);
    result.fold(
      (failure) => emit(ClassroomDetailsFailure(failure.message)),
      (response) => emit(ClassroomDetailsSuccess(response)),
    );
  }
}
