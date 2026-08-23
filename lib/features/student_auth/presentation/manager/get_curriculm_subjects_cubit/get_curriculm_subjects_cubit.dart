import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_auth/data/debug/gulf_registration_diagnostics.dart';

class GetCurriculmSubjectsCubit extends Cubit<GetCurriculmSubjectsState> {
  GetCurriculmSubjectsCubit(this.authRepo) : super(GetSubjectsInitial());

  final AuthRepo authRepo;
  int _requestVersion = 0;

  Future<void> getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
    bool isGulf = false,
  }) async {
    if (isClosed) return;
    final version = ++_requestVersion;
    emit(GetSubjectsLoading());

    final result = isGulf
        ? await authRepo.getGulfGradeSubjects(gradeId: gradeId)
        : await authRepo.getCurriculumSubjects(
            curriculumId: curriculumId,
            gradeId: gradeId,
          );
    if (isClosed || version != _requestVersion) return;

    result.fold((failure) {
      if (isGulf) {
        GulfRegistrationDiagnostics.uiFailure(
          endpoint: EndPoints.gradeSubjects(gradeId),
          cubit: 'GetCurriculmSubjectsCubit',
          state: 'GetSubjectsFailure',
          message: failure.message,
        );
      }
      emit(GetSubjectsFailure(errorMessage: failure.message));
    }, (response) => emit(GetSubjectsSuccess(subjects: response.subjects)));
  }
}
