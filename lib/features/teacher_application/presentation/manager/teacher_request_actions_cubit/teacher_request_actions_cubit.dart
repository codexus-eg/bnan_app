import 'package:bnan_app/features/teacher_application/data/models/teacher_status_request_model.dart';
import 'package:bnan_app/features/teacher_application/data/repo/teacher_requests_repo.dart';
import 'package:bnan_app/features/teacher_application/presentation/manager/teacher_request_actions_cubit/teacher_request_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherRequestActionsCubit extends Cubit<TeacherRequestActionsState> {
  TeacherRequestActionsCubit(this.teacherRequestsRepo)
    : super(TeacherRequestActionsInitial());

  final TeacherRequestsRepo teacherRequestsRepo;

  Future<void> approveTeacherRequest(String teacherId) async {
    if (isClosed) return;
    emit(TeacherRequestActionsLoading());

    final result = await teacherRequestsRepo.updateTeacherStatus(
      teacherId,
      TeacherStatusRequestModel(status: 'approved'),
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(TeacherRequestActionsFailure(failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(ApproveTeacherRequestSuccess());
      },
    );
  }

  Future<void> rejectTeacherRequest(String teacherId) async {
    if (isClosed) return;
    emit(TeacherRequestActionsLoading());

    final result = await teacherRequestsRepo.updateTeacherStatus(
      teacherId,
      TeacherStatusRequestModel(status: 'rejected'),
    );
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(TeacherRequestActionsFailure(failure.message));
      },
      (_) {
        if (isClosed) return;
        emit(RejectTeacherRequestSuccess());
      },
    );
  }
}
