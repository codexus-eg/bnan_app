import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';

class GetGradesCubit extends Cubit<GetGradesState> {
  GetGradesCubit(this.authRepo) : super(GetGradesInitial());

  final AuthRepo authRepo;
  int _requestVersion = 0;

  Future<void> getCurriculumGrades({
    required String curriculumId,
    bool isGulf = false,
  }) async {
    if (isClosed) return;
    final version = ++_requestVersion;
    emit(GetGradesLoading());

    final result = isGulf
        ? await authRepo.getGulfCurriculumGrades(curriculumId: curriculumId)
        : await authRepo.getCurriculumGrades(curriculumId: curriculumId);
    if (isClosed || version != _requestVersion) return;

    result.fold(
      (failure) {
        if (isGulf) {
          GulfRegistrationDiagnostics.uiFailure(
            endpoint: EndPoints.gradesByCurriculum(curriculumId),
            cubit: 'GetGradesCubit',
            state: 'GetGradesFailure',
            message: failure.message,
          );
        }
        emit(GetGradesFailure(errorMessage: failure.message));
      },
      (response) => emit(
        GetGradesSuccess(
          grades: response.data.where((grade) => grade.isActive).toList(),
        ),
      ),
    );
  }
}
