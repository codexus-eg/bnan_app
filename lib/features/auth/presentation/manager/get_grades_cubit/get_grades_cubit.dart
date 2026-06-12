import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetGradesCubit extends Cubit<GetGradesState> {
  GetGradesCubit(this.authRepo) : super(GetGradesInitial());

  final AuthRepo authRepo;

  Future<void> getCurriculumGrades({
    required String curriculumId,
  }) async {
    emit(GetGradesLoading());

    final result = await authRepo.getCurriculumGrades(
      curriculumId: curriculumId,
    );

    result.fold(
      (failure) => emit(GetGradesFailure(errorMessage: failure.message)),
      (response) => emit(GetGradesSuccess(grades: response.grades)),
    );
  }
}