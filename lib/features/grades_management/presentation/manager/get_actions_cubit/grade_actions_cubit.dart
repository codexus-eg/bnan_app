import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/data/repo/grades_repo.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeActionsCubit extends Cubit<GradeActionsState> {
  GradeActionsCubit(this.gradesRepo) : super(GradeActionsInitial());

  final GradesRepo gradesRepo;

  Future<void> createGrade(CreateGradeRequestModel model) async {
    if (isClosed) return;
    emit(CreateGradeLoading());

    final result = await gradesRepo.createGrade(model);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(CreateGradeFailure(failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(CreateGradeSuccess());
      },
    );
  }

  Future<void> deleteGrade(String gradeId) async {
    if (isClosed) return;
    emit(DeleteGradeLoading());

    final result = await gradesRepo.deleteGrade(gradeId);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(DeleteGradeFailure(failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(DeleteGradeSuccess());
      },
    );
  }
}
