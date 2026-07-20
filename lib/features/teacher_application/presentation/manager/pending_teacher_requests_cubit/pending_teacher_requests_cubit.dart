import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/pending_teacher_requests_cubit/pending_teacher_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PendingTeacherRequestsCubit
    extends Cubit<PendingTeacherRequestsState> {
  PendingTeacherRequestsCubit(this.teacherRequestsRepo)
      : super(PendingTeacherRequestsInitial());

  final TeacherRequestsRepo teacherRequestsRepo;

  Future<void> getPendingTeacherRequests() async {
    emit(PendingTeacherRequestsLoading());

    final result = await teacherRequestsRepo.getPendingTeacherRequests();
    result.fold(
      (failure) => emit(PendingTeacherRequestsFailure(failure.message)),
      (response) => emit(PendingTeacherRequestsSuccess(response)),
    );
  }
}