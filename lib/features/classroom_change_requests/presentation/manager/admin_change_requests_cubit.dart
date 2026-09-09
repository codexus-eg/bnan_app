import 'dart:ui';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/classroom_change_requests/data/repo/classroom_change_requests_repo.dart';
import 'package:bnan_app/features/classroom_change_requests/presentation/manager/admin_change_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminChangeRequestsCubit extends Cubit<AdminChangeRequestsState> {
  AdminChangeRequestsCubit(this._repo, [this._socket])
    : super(const AdminChangeRequestsInitial()) {
    _initSocket();
  }
  final ClassroomChangeRequestsRepo _repo;
  final SocketService? _socket;
  VoidCallback? _socketDisposer;
  bool hasLoaded = false;

  void _initSocket() {
    final socket = _socket;
    if (socket == null) return;
    _socketDisposer = socket.listenToNotification((payload) {
      final key = (payload['key'] ??
              (payload['data'] is Map ? payload['data']['key'] : null))
          ?.toString()
          .trim()
          .toUpperCase();
      if (key == 'CLASSROOM_CHANGE_REQUESTED') {
        load(silent: true);
      }
    });
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const AdminChangeRequestsLoading());
    final result = await _repo.getAdminRequests();
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!silent) emit(AdminChangeRequestsFailure(failure.message));
      },
      (page) {
        hasLoaded = true;
        emit(AdminChangeRequestsSuccess(page.requests));
      },
    );
  }

  @override
  Future<void> close() {
    _socketDisposer?.call();
    return super.close();
  }

  getDetails(String id) => _repo.getAdminRequest(id);
}
