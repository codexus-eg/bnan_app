import 'dart:ui';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classrooms_cubit/classrooms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomsCubit extends Cubit<ClassroomsState> {
  ClassroomsCubit(this.classroomsRepo, [this._socket])
      : super(ClassroomsInitial()) {
    _initSocket();
  }

  final ClassroomsRepo classroomsRepo;
  final SocketService? _socket;
  VoidCallback? _socketDisposer;
  int _requestVersion = 0;

  void _initSocket() {
    final socket = _socket;
    if (socket == null) return;
    _socketDisposer = socket.listenToNotification((payload) {
      final key = (payload['key'] ??
              (payload['data'] is Map ? payload['data']['key'] : null))
          ?.toString()
          .trim()
          .toUpperCase();
      if (key != null &&
          (key.contains('CLASSROOM') ||
              key.contains('TEACHER') ||
              key.contains('ASSIGN'))) {
        getClassrooms(silent: true);
      }
    });
  }

  Future<void> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
    String? keyword,
    bool silent = false,
  }) async {
    if (isClosed) return;
    final version = ++_requestVersion;
    if (!silent) emit(ClassroomsLoading());

    final result = await classroomsRepo.getClassrooms(
      page: page,
      limit: limit,
      curriculum: curriculum,
      keyword: keyword,
    );
    if (isClosed || version != _requestVersion) return;
    result.fold(
      (failure) {
        if (!silent) emit(ClassroomsFailure(failure.message));
      },
      (response) => emit(ClassroomsSuccess(response)),
    );
  }

  @override
  Future<void> close() {
    _socketDisposer?.call();
    return super.close();
  }
}
