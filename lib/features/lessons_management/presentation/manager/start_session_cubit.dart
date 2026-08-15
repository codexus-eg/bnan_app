import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartSessionCubit extends Cubit<StartSessionState> {
  StartSessionCubit(this.repo) : super(const StartSessionState());
  final StartSessionRepo repo;
  final Map<String, int> _requestIds = {};
  final Map<String, int> _activeRequestIds = {};

  Future<void> loadActive(String classroomId) async {
    final classroom = classroomId.trim();
    if (classroom.isEmpty || state.isChecking(classroom)) return;
    final requestId = (_activeRequestIds[classroom] ?? 0) + 1;
    _activeRequestIds[classroom] = requestId;
    emit(
      state.copyWith(
        checkingClassroomIds: {...state.checkingClassroomIds, classroom},
      ),
    );
    final result = await repo.getActiveSession(classroomId: classroom);
    if (isClosed || _activeRequestIds[classroom] != requestId) return;
    final checking = {...state.checkingClassroomIds}..remove(classroom);
    result.fold(
      (failure) => emit(
        state.copyWith(
          checkingClassroomIds: checking,
          eventClassroomId: classroom,
          eventError: failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (data) {
        final active = {...state.activeByClassroom};
        if (data == null || !data.session.isActive) {
          active.remove(classroom);
        } else {
          active[classroom] = data;
        }
        emit(
          state.copyWith(
            checkingClassroomIds: checking,
            checkedClassroomIds: {...state.checkedClassroomIds, classroom},
            activeByClassroom: active,
          ),
        );
      },
    );
  }

  Future<bool> start({
    required String classroomId,
    required String subjectId,
  }) async {
    final classroom = classroomId.trim();
    final subject = subjectId.trim();
    if (classroom.isEmpty) return _reject(StartSessionIssue.missingClassroom);
    if (subject.isEmpty) return _reject(StartSessionIssue.missingSubject);
    if (state.isLoading(classroom) || state.active(classroom) != null) {
      return false;
    }
    final requestId = (_requestIds[classroom] ?? 0) + 1;
    _requestIds[classroom] = requestId;
    emit(
      state.copyWith(
        loadingClassroomIds: {...state.loadingClassroomIds, classroom},
        eventClassroomId: null,
        eventError: null,
        eventCode: null,
        eventStatusCode: null,
        eventIssue: null,
        eventSuccess: false,
      ),
    );
    final result = await repo.startSession(
      classroomId: classroom,
      subjectId: subject,
    );
    if (!_isCurrent(classroom, requestId)) return false;
    final loading = {...state.loadingClassroomIds}..remove(classroom);
    var succeeded = false;
    var refreshActive = false;
    result.fold(
      (failure) {
        refreshActive =
            failure.code == 'CLASSROOM_SESSION_ALREADY_ACTIVE' ||
            failure.message.contains('CLASSROOM_SESSION_ALREADY_ACTIVE');
        emit(
          state.copyWith(
            loadingClassroomIds: loading,
            eventClassroomId: classroom,
            eventError: failure.message,
            eventCode: failure.code,
            eventStatusCode: failure.statusCode,
            eventIssue: null,
            eventSuccess: false,
            eventId: state.eventId + 1,
          ),
        );
      },
      (data) {
        succeeded = true;
        emit(
          state.copyWith(
            loadingClassroomIds: loading,
            startedByClassroom: {...state.startedByClassroom, classroom: data},
            activeByClassroom: {...state.activeByClassroom, classroom: data},
            checkedClassroomIds: {...state.checkedClassroomIds, classroom},
            eventClassroomId: classroom,
            eventError: null,
            eventCode: null,
            eventStatusCode: null,
            eventIssue: null,
            eventSuccess: true,
            eventId: state.eventId + 1,
          ),
        );
      },
    );
    if (refreshActive) await loadActive(classroom);
    return succeeded;
  }

  Future<String?> join(String classroomId) async {
    final classroom = classroomId.trim();
    if (classroom.isEmpty || state.isLoading(classroom)) return null;
    emit(
      state.copyWith(
        joiningClassroomIds: {...state.joiningClassroomIds, classroom},
        eventError: null,
        eventCode: null,
        eventStatusCode: null,
      ),
    );
    final result = await repo.joinActiveSession(classroomId: classroom);
    if (isClosed) return null;
    final joining = {...state.joiningClassroomIds}..remove(classroom);
    String? link;
    result.fold(
      (failure) => emit(
        state.copyWith(
          joiningClassroomIds: joining,
          eventClassroomId: classroom,
          eventError: failure.statusCode == 404
              ? 'SESSION_NOT_ACTIVE'
              : failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (value) {
        link = value;
        emit(state.copyWith(joiningClassroomIds: joining));
      },
    );
    return link;
  }

  Future<bool> end(String classroomId) async {
    final classroom = classroomId.trim();
    final session = state.active(classroom)?.session;
    final sessionId = session?.id.trim() ?? '';
    if (sessionId.isEmpty) {
      emit(
        state.copyWith(
          eventClassroomId: classroom,
          eventError: 'معرّف الجلسة غير صالح',
          eventCode: 'INVALID_SESSION_ID',
          eventId: state.eventId + 1,
        ),
      );
      return false;
    }
    if (state.isLoading(classroom)) return false;
    emit(
      state.copyWith(
        endingClassroomIds: {...state.endingClassroomIds, classroom},
      ),
    );
    final result = await repo.endSession(sessionId: sessionId);
    if (isClosed) return false;
    final ending = {...state.endingClassroomIds}..remove(classroom);
    var succeeded = false;
    result.fold(
      (failure) => emit(
        state.copyWith(
          endingClassroomIds: ending,
          eventError: failure.message,
          eventCode: failure.code,
          eventStatusCode: failure.statusCode,
          eventId: state.eventId + 1,
        ),
      ),
      (_) {
        succeeded = true;
        emit(state.copyWith(endingClassroomIds: ending));
      },
    );
    if (succeeded) await loadActive(classroom);
    return succeeded;
  }

  bool _reject(StartSessionIssue issue) {
    emit(
      state.copyWith(
        eventIssue: issue,
        eventError: null,
        eventSuccess: false,
        eventId: state.eventId + 1,
      ),
    );
    return false;
  }

  bool _isCurrent(String classroomId, int requestId) =>
      !isClosed && _requestIds[classroomId] == requestId;
}
