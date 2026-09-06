import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomsCubit extends Cubit<ClassroomsState> {
  ClassroomsCubit(this.classroomsRepo) : super(ClassroomsInitial());

  final ClassroomsRepo classroomsRepo;
  int _requestVersion = 0;

  Future<void> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
  }) async {
    if (isClosed) return;
    final version = ++_requestVersion;
    emit(ClassroomsLoading());

    final result = await classroomsRepo.getClassrooms(
      page: page,
      limit: limit,
      curriculum: curriculum,
    );
    if (isClosed || version != _requestVersion) return;
    result.fold(
      (failure) => emit(ClassroomsFailure(failure.message)),
      (response) => emit(ClassroomsSuccess(response)),
    );
  }
}
