import 'package:bnan_app/features/teacher_assignment/data/repo/assignments_repo.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_grades/get_teacher_grades_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTeacherGradesCubit extends Cubit<GetTeacherGradesState> {
  GetTeacherGradesCubit(this.assignmentsRepo) : super(GetTeacherGradesInitial());

  final AssignmentsRepo assignmentsRepo;

  Future<void> getGradesByCurriculum({required String curriculumId}) async {
    emit(GetTeacherGradesLoading());

    final result = await assignmentsRepo.getGradesByCurriculum(
      curriculumId: curriculumId,
    );

    result.fold(
      (failure) {
        emit(GetTeacherGradesFailure(errorMessage: failure.message));
      },
      (grades) {
        emit(GetTeacherGradesSuccess(grades: grades));
      },
    );
  }
}