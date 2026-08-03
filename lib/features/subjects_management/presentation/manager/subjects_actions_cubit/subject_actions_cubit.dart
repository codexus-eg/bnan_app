import 'package:bnan_app/features/subjects_management/data/models/subject_request_model.dart';
import 'package:bnan_app/features/subjects_management/data/repo/subjects_repo.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectActionsCubit extends Cubit<SubjectActionsState> {
  SubjectActionsCubit(this.subjectsRepo) : super(SubjectActionsInitial());

  final SubjectsRepo subjectsRepo;

  Future<void> addSubject({
    required String name,
    required String curriculumId,
    required String gradeId,
  }) async {
    if (state is AddSubjectLoading) return;
    emit(AddSubjectLoading());
    final result = await subjectsRepo.addSubject(
      request: AddSubjectRequestModel(
        name: name,
        curriculumId: curriculumId,
        gradeId: gradeId,
      ),
    );
    result.fold(
      (failure) => emit(AddSubjectFailure(failure.message)),
      (_) => emit(AddSubjectSuccess()),
    );
  }

  Future<void> updateSubject({
    required String subjectId,
    required String name,
  }) async {
    emit(UpdateSubjectLoading());
    final result = await subjectsRepo.updateSubject(
      subjectId: subjectId,
      request: UpdateSubjectRequestModel(name: name),
    );
    result.fold(
      (failure) => emit(UpdateSubjectFailure(failure.message)),
      (_) => emit(UpdateSubjectSuccess()),
    );
  }
}
