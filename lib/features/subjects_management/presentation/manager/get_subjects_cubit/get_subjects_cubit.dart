import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSubjectsCubit extends Cubit<GetSubjectsState> {
  GetSubjectsCubit(this.subjectsRepo) : super(GetSubjectsInitial());

  final SubjectsRepo subjectsRepo;

  Future<void> getSubjects() async {
    emit(GetSubjectsLoading());

    final result = await subjectsRepo.getSubjects();

    result.fold(
      (failure) {
        emit(GetSubjectsFailure(errorMessage: failure.message));
      },
      (subjects) {
        emit(GetSubjectsSuccess(subjects: subjects));
      },
    );
  }
}
