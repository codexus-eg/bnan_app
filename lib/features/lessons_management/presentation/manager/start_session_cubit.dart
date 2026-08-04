import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/start_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartSessionCubit extends Cubit<StartSessionState> {
  StartSessionCubit(this.repo) : super(const StartSessionState());
  final StartSessionRepo repo;
  final Map<String, int> _requestIds = {};

  Future<bool> start({
    required String classroomId,
    required String subjectId,
  }) async {
    final classroom = classroomId.trim();
    final subject = subjectId.trim();
    if (classroom.isEmpty) return _reject(StartSessionIssue.missingClassroom);
    if (subject.isEmpty) return _reject(StartSessionIssue.missingSubject);
    if (state.isLoading(classroom) || state.started(classroom) != null) {
      return false;
    }
    final requestId = (_requestIds[classroom] ?? 0) + 1;
    _requestIds[classroom] = requestId;
    emit(
      state.copyWith(
        loadingClassroomIds: {...state.loadingClassroomIds, classroom},
        eventClassroomId: null,
        eventError: null,
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
    result.fold(
      (failure) => emit(
        state.copyWith(
          loadingClassroomIds: loading,
          eventClassroomId: classroom,
          eventError: failure.message,
          eventIssue: null,
          eventSuccess: false,
          eventId: state.eventId + 1,
        ),
      ),
      (data) {
        succeeded = true;
        emit(
          state.copyWith(
            loadingClassroomIds: loading,
            startedByClassroom: {...state.startedByClassroom, classroom: data},
            eventClassroomId: classroom,
            eventError: null,
            eventIssue: null,
            eventSuccess: true,
            eventId: state.eventId + 1,
          ),
        );
      },
    );
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
