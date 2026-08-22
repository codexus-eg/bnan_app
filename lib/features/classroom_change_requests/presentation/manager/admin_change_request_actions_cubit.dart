import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_request_actions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestActionsCubit
    extends Cubit<AdminChangeRequestActionsState> {
  AdminChangeRequestActionsCubit(this._repo)
    : super(const AdminChangeRequestActionIdle());
  final ClassroomChangeRequestsRepo _repo;
  Future<void> Function()? onRefresh;

  bool loading(String id, AdminChangeRequestAction action) =>
      state is AdminChangeRequestActionLoading &&
      (state as AdminChangeRequestActionLoading).id == id &&
      (state as AdminChangeRequestActionLoading).action == action;

  Future<void> approve(String id, String classroomSubjectId, String notes) =>
      _perform(
        id,
        AdminChangeRequestAction.approve,
        () => _repo.approve(
          id,
          classroomSubjectId: classroomSubjectId,
          adminNotes: notes,
        ),
      );

  Future<void> reject(String id, String reason) => _perform(
    id,
    AdminChangeRequestAction.reject,
    () => _repo.reject(id, rejectionReason: reason),
  );

  Future<void> _perform(
    String id,
    AdminChangeRequestAction action,
    Future<Either<Failure, String>> Function() call,
  ) async {
    emit(AdminChangeRequestActionLoading(id, action));
    final result = await call();
    if (isClosed) return;
    await result.fold<Future<void>>(
      (failure) async =>
          emit(AdminChangeRequestActionFailure(id, failure.message)),
      (_) async {
        emit(AdminChangeRequestActionSuccess(id, action));
        await onRefresh?.call();
      },
    );
  }
}
