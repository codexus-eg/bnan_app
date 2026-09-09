import 'dart:ui';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'teacher_subject_assignments_state.dart';

class TeacherSubjectAssignmentsCubit
    extends Cubit<TeacherSubjectAssignmentsState> {
  TeacherSubjectAssignmentsCubit(this.repo, [this._socket])
    : super(const TeacherSubjectAssignmentsInitial()) {
    _initSocket();
  }

  final TeacherSubjectAssignmentRepo repo;
  final SocketService? _socket;
  VoidCallback? _socketDisposer;

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
        getTeacherTeachingAssignments(silent: true);
      }
    });
  }

  Future<void> getTeacherTeachingAssignments({bool silent = false}) async {
    if (isClosed) return;
    if (!silent) emit(const GetTeachingAssignmentsLoading());

    final result = await repo.getTeacherTeachingAssignments();
    if (isClosed) return;
    result.fold(
      (failure) {
        if (isClosed) return;
        if (!silent) emit(GetTeachingAssignmentsFailure(failure.message));
      },
      (response) {
        if (isClosed) return;
        if (response.data.isEmpty) {
          emit(const GetTeachingAssignmentsEmpty());
        } else {
          emit(GetTeachingAssignmentsSuccess(assignments: response.data));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _socketDisposer?.call();
    return super.close();
  }
}
