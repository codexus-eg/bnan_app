import 'package:bnan_app/features/grades_management/data/repo/grades_repo.dart';
import 'package:bnan_app/features/grades_management/presentation/manager/get_grades_management_cubit/get_grades_management_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetGradesmanagementCubit extends Cubit<GetGradesManagementState> {
  GetGradesmanagementCubit(this.gradesRepo) : super(GetGradesInitial());

  final GradesRepo gradesRepo;

  Future<void> getGrades() async {
    if (isClosed) return;
    emit(GetGradesLoading());

    final result = await gradesRepo.getGrades();
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(GetGradesFailure(errorMessage: failure.message));
      },
      (grades) {
        if (isClosed) return;
        emit(GetGradesSuccess(grades: grades));
      },
    );
  }
}
