import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/teacher_details_cubit/teacher_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherDetailsCubit extends Cubit<TeacherDetailsState> {
  TeacherDetailsCubit(this.teacherRequestsRepo)
      : super(TeacherDetailsInitial());

  final TeacherRequestsRepo teacherRequestsRepo;

  Future<void> getTeacherDetails(String teacherId) async {
    emit(TeacherDetailsLoading());

    final result = await teacherRequestsRepo.getTeacherDetails(teacherId);
    result.fold(
      (failure) => emit(TeacherDetailsFailure(failure.message)),
      (response) => emit(TeacherDetailsSuccess(response)),
    );
  }
}