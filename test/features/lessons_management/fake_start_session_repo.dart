import 'dart:async';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:dartz/dartz.dart';

class FakeStartSessionRepo implements StartSessionRepo {
  final calls = <({String classroomId, String subjectId})>[];
  final pending = <String, Completer<Either<Failure, StartSessionData>>>{};
  Failure? failure;
  bool defer = false;

  @override
  Future<Either<Failure, StartSessionData>> startSession({
    required String classroomId,
    required String subjectId,
  }) async {
    calls.add((classroomId: classroomId, subjectId: subjectId));
    if (defer) {
      final completer = Completer<Either<Failure, StartSessionData>>();
      pending[classroomId] = completer;
      return completer.future;
    }
    if (failure != null) return Left(failure!);
    return Right(startedSessionData(classroomId));
  }

  @override
  Future<Either<Failure, StartSessionData?>> getActiveSession({
    required String classroomId,
  }) async => Right(startedSessionData(classroomId));

  @override
  Future<Either<Failure, String>> joinActiveSession({
    required String classroomId,
  }) async => Right('https://zoom.us/j/$classroomId');

  @override
  Future<Either<Failure, void>> endSession({required String sessionId}) async =>
      const Right(null);
}

StartSessionData startedSessionData(String classroomId) => StartSessionData(
  session: StartedSession(
    id: 'session-$classroomId',
    status: 'starting',
    activeOccurrence: true,
    startAt: DateTime.utc(2026, 8, 4, 12),
  ),
  meetingLink: 'https://zoom.us/j/$classroomId',
);
