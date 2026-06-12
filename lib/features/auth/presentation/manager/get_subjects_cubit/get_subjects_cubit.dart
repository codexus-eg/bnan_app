import 'package:bnan_app/features/auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/auth/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSubjectsCubit extends Cubit<GetSubjectsState> {
  GetSubjectsCubit(this.authRepo) : super(GetSubjectsInitial());

  final AuthRepo authRepo;

  Future<void> getCurriculumSubjects({
    required String curriculumId,
    required String gradeId,
  }) async {
    emit(GetSubjectsLoading());

    final result = await authRepo.getCurriculumSubjects(
      curriculumId: curriculumId,
      gradeId: gradeId,
    );

    result.fold(
      (failure) => emit(GetSubjectsFailure(errorMessage: failure.message)),
      (response) => emit(GetSubjectsSuccess(subjects: response.subjects)),
    );
  }
}