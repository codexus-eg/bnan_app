import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recording_model.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summaries_response.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_documents_state.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_recordings_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/classroom_summaries_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('recordings load, cache, refresh, empty and failure', () async {
    final repo = _Repo();
    final cubit = ClassroomRecordingsCubit(repo);
    repo.recordings = const ClassroomRecordingsResponse([
      ClassroomRecordingModel(sessionName: 'Math', recordingLink: null),
    ]);
    final states = <ClassroomDocumentsState<ClassroomRecordingModel>>[];
    final subscription = cubit.stream.listen(states.add);
    await cubit.load('c');
    expect(states.first, isA<DocumentsLoading>());
    expect(cubit.state, isA<DocumentsSuccess>());
    await cubit.load('c');
    expect(repo.recordingCalls, 1);
    repo.recordings = const ClassroomRecordingsResponse([]);
    await cubit.load('c', refresh: true);
    expect(cubit.state, isA<DocumentsEmpty>());
    expect(repo.recordingCalls, 2);
    repo.failure = true;
    await cubit.load('c', refresh: true);
    expect(cubit.state, isA<DocumentsFailure>());
    await subscription.cancel();
    await cubit.close();
  });

  test(
    'summaries are independent, cache successful result and retry',
    () async {
      final repo = _Repo();
      final cubit = ClassroomSummariesCubit(repo);
      expect(cubit.state, isA<DocumentsInitial>());
      await cubit.load('c');
      expect(cubit.state, isA<DocumentsEmpty>());
      await cubit.load('c');
      expect(repo.summaryCalls, 1);
      repo.failure = true;
      await cubit.load('c', refresh: true);
      expect(cubit.state, isA<DocumentsFailure>());
      await cubit.close();
    },
  );
}

class _Repo implements ClassroomDocumentsRepo {
  int recordingCalls = 0, summaryCalls = 0;
  bool failure = false;
  ClassroomRecordingsResponse recordings = const ClassroomRecordingsResponse(
    [],
  );

  @override
  getRecordings(String classroomId) async {
    recordingCalls++;
    return failure
        ? Left<Failure, ClassroomRecordingsResponse>(Failure(message: 'error'))
        : Right(recordings);
  }

  @override
  getSummaries(String classroomId) async {
    summaryCalls++;
    return failure
        ? Left<Failure, ClassroomSummariesResponse>(Failure(message: 'error'))
        : const Right(ClassroomSummariesResponse([]));
  }
}
