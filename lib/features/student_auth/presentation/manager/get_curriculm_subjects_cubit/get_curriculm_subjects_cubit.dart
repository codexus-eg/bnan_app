import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCurriculmSubjectsCubit extends Cubit<GetCurriculmSubjectsState> {
  GetCurriculmSubjectsCubit(this.authRepo) : super(GetSubjectsInitial());

  final AuthRepo authRepo;

  Future<void> getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
    bool isGulf = false,
  }) async {
    emit(GetSubjectsLoading());

    final result = isGulf
        ? await authRepo.getGulfGradeSubjects(gradeId: gradeId)
        : await authRepo.getCurriculumSubjects(
            curriculumId: curriculumId,
            gradeId: gradeId,
          );

    result.fold(
      (failure) => emit(GetSubjectsFailure(errorMessage: failure.message)),
      (response) => emit(GetSubjectsSuccess(subjects: response.subjects)),
    );
  }
}
