import 'dart:ui';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/classrooms_management/data/repo/classrooms_repo.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_details_cubit/classroom_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomDetailsCubit extends Cubit<ClassroomDetailsState> {
  ClassroomDetailsCubit(this.classroomsRepo, [this._socket])
      : super(ClassroomDetailsInitial()) {
    _initSocket();
  }

  final ClassroomsRepo classroomsRepo;
  final SocketService? _socket;
  VoidCallback? _socketDisposer;
  String? _currentClassroomId;

  void _initSocket() {
    final socket = _socket;
    if (socket == null) return;
    _socketDisposer = socket.listenToNotification((payload) {
      final key = (payload['key'] ??
              (payload['data'] is Map ? payload['data']['key'] : null))
          ?.toString()
          .trim()
          .toUpperCase();
      if (key == 'CLASSROOM_TEACHER_CHANGED') {
        final targetClassroomId = (payload['classroomId'] ??
                (payload['data'] is Map ? payload['data']['classroomId'] : null))
            ?.toString()
            .trim();
        if (_currentClassroomId != null &&
            (targetClassroomId == null ||
                targetClassroomId.isEmpty ||
                targetClassroomId == _currentClassroomId)) {
          getClassroomDetails(_currentClassroomId!, silent: true);
        }
      }
    });
  }

  Future<void> getClassroomDetails(
    String classroomId, {
    bool silent = false,
  }) async {
    if (isClosed) return;
    _currentClassroomId = classroomId;
    if (!silent) emit(ClassroomDetailsLoading());

    final result = await classroomsRepo.getClassroomDetails(classroomId);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!silent) emit(ClassroomDetailsFailure(failure.message));
      },
      (response) => emit(ClassroomDetailsSuccess(response)),
    );
  }

  @override
  Future<void> close() {
    _socketDisposer?.call();
    return super.close();
  }
}
