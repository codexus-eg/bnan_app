import 'package:bnan_app/features/grades_management/data/models/create_grade_request_model.dart';
import 'package:bnan_app/features/grades_management/data/repo/grades_repo.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_actions_cubit/grade_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeActionsCubit extends Cubit<GradeActionsState> {
  GradeActionsCubit(this.gradesRepo) : super(GradeActionsInitial());

  final GradesRepo gradesRepo;

  Future<void> createGrade(CreateGradeRequestModel model) async {
    emit(CreateGradeLoading());

    final result = await gradesRepo.createGrade(model);

    result.fold(
      (failure) => emit(CreateGradeFailure(failure.message)),
      (_) => emit(CreateGradeSuccess()),
    );
  }

  Future<void> deleteGrade(String gradeId) async {
    emit(DeleteGradeLoading());

    final result = await gradesRepo.deleteGrade(gradeId);

    result.fold(
      (failure) => emit(DeleteGradeFailure(failure.message)),
      (_) => emit(DeleteGradeSuccess()),
    );
  }
}