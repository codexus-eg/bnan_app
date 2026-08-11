import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/admin_subject_requests/data/models/admin_subject_request_approval.dart';
import 'package:bnan_app/features/admin_subject_requests/data/repo/admin_subject_requests_repo.dart';
import 'package:bnan_app/features/admin_subject_requests/presentation/manager/admin_subject_request_actions_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSubjectRequestActionsCubit
    extends Cubit<AdminSubjectRequestActionsState> {
  AdminSubjectRequestActionsCubit(this._repo)
    : super(const AdminSubjectRequestActionIdle());
  final AdminSubjectRequestsRepo _repo;
  final Set<String> _loading = {};
  Future<void> Function()? onRefresh;

  bool isLoading(String id, AdminSubjectRequestAction action) =>
      _loading.contains('$id-${action.name}');

  Future<void> approve(String id, AdminSubjectRequestApproval approval) =>
      _perform(
        id,
        AdminSubjectRequestAction.approve,
        () => _repo.approve(requestId: id, approval: approval),
      );

  Future<void> reject(String id) =>
      _perform(id, AdminSubjectRequestAction.reject, () => _repo.reject(id));

  Future<void> _perform(
    String id,
    AdminSubjectRequestAction action,
    Future<Either<Failure, String>> Function() request,
  ) async {
    final key = '$id-${action.name}';
    if (_loading.contains(key)) return;
    _loading.add(key);
    emit(AdminSubjectRequestActionLoading(id, action));
    try {
      final result = await request();
      if (isClosed) return;
      await result.fold<Future<void>>(
        (failure) async {
          emit(
            AdminSubjectRequestActionFailure(
              id,
              action,
              failure.message,
              code: failure.code,
              statusCode: failure.statusCode,
            ),
          );
          if (failure.statusCode == 409 ||
              failure.code == 'SUBJECT_REQUEST_NOT_AWAITING_APPROVAL') {
            await onRefresh?.call();
          }
        },
        (message) async {
          emit(AdminSubjectRequestActionSuccess(id, action, message));
          await onRefresh?.call();
        },
      );
    } finally {
      _loading.remove(key);
    }
  }
}
