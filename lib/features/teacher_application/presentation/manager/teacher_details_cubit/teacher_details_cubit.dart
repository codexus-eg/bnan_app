import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/teacher_details_cubit/teacher_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherDetailsCubit extends Cubit<TeacherDetailsState> {
  TeacherDetailsCubit(this.teacherRequestsRepo)
    : super(TeacherDetailsInitial());

  final TeacherRequestsRepo teacherRequestsRepo;

  Future<void> getTeacherDetails(String teacherId) async {
    if (isClosed) return;
    emit(TeacherDetailsLoading());

    final result = await teacherRequestsRepo.getTeacherDetails(teacherId);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(TeacherDetailsFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        emit(TeacherDetailsSuccess(response));
      },
    );
  }
}
