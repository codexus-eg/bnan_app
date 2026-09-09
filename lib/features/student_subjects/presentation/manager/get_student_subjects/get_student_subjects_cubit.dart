import 'dart:ui';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/student_subjects/data/repo/student_subjects_repo.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMySubjectsCubit extends Cubit<GetMySubjectsState> {
  GetMySubjectsCubit(this.repo, [this._socket])
      : super(GetMySubjectsInitial()) {
    _initSocket();
  }

  final StudentSubjectsRepo repo;
  final SocketService? _socket;
  VoidCallback? _socketDisposer;
  bool _loading = false;

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
        loadSubjects(silent: true);
      }
    });
  }

  Future<void> loadSubjects({bool silent = false}) async {
    if (_loading || isClosed) return;
    _loading = true;
    if (!silent) emit(GetMySubjectsLoading());
    final result = await repo.getMySubjects();
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!silent) {
          emit(
            failure.statusCode == 401
                ? GetMySubjectsUnauthorized()
                : GetMySubjectsFailure(failure.message),
          );
        }
      },
      (subjects) => emit(
        subjects.isEmpty
            ? GetMySubjectsEmpty()
            : GetMySubjectsSuccess(subjects),
      ),
    );
    _loading = false;
  }

  @override
  Future<void> close() {
    _socketDisposer?.call();
    return super.close();
  }

  Future<void> retry() => loadSubjects();
}
