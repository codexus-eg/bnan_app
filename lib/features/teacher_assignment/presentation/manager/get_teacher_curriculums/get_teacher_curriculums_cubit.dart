import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_curriculums/get_teacher_curriculums_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherCurriculumsCubit extends Cubit<GetTeacherCurriculumsState> {
  GetTeacherCurriculumsCubit(this.assignmentsRepo)
    : super(GetTeacherCurriculumsInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> getMyCurriculums() async {
    emit(GetTeacherCurriculumsLoading());

    final result = await assignmentsRepo.getMyCurriculums();

    result.fold(
      (failure) {
        emit(GetTeacherCurriculumsFailure(errorMessage: failure.message));
      },
      (curriculums) {
        emit(GetTeacherCurriculumsSuccess(curriculums: curriculums));
      },
    );
  }
}