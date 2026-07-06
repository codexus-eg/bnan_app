import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomsCubit extends Cubit<ClassroomsState> {
  ClassroomsCubit(this.classroomsRepo) : super(ClassroomsInitial());

  final ClassroomsRepo classroomsRepo;

  Future<void> getClassrooms() async {
    emit(ClassroomsLoading());

    final result = await classroomsRepo.getClassrooms();
    result.fold(
      (failure) => emit(ClassroomsFailure(failure.message)),
      (response) => emit(ClassroomsSuccess(response)),
    );
  }
}
