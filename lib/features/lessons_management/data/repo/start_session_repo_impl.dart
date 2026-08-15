import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/lessons_management/data/models/start_session_models.dart';
import 'package:bnan_app/features/lessons_management/data/repo/start_session_repo.dart';
import 'package:dartz/dartz.dart';

class StartSessionRepoImpl implements StartSessionRepo {
  const StartSessionRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, StartSessionData>> startSession({
    required String classroomId,
    required String subjectId,
  }) => repoGuard(() async {
    final response = await api.post(
      EndPoints.startClassroomSession(classroomId),
      data: {'subjectId': subjectId},
      isProtected: true,
    );
    return StartSessionResponse.fromJson(asMap(response)).data;
  });

  @override
  Future<Either<Failure, StartSessionData?>> getActiveSession({
    required String classroomId,
  }) async {
    final result = await repoGuard(() async {
      final response = await api.get(
        EndPoints.activeClassroomSession(classroomId),
        isProtected: true,
      );
      final root = asMap(response);
      final data = root['data'];
      if (data == null) return null;
      return StartSessionData.fromJson(
        data is Map ? Map<String, dynamic>.from(data) : root,
      );
    });
    return result.fold(
      (failure) =>
          failure.statusCode == 404 || failure.code == 'SESSION_NOT_ACTIVE'
          ? const Right(null)
          : Left(failure),
      Right.new,
    );
  }

  @override
  Future<Either<Failure, String>> joinActiveSession({
    required String classroomId,
  }) => repoGuard(() async {
    final response = asMap(
      await api.get(
        EndPoints.joinActiveClassroomSession(classroomId),
        isProtected: true,
      ),
    );
    final data = response['data'];
    final map = data is Map ? Map<String, dynamic>.from(data) : response;
    return (map['meetingLink'] ?? '').toString().trim();
  });

  @override
  Future<Either<Failure, void>> endSession({required String sessionId}) =>
      repoGuard(() async {
        await api.post(EndPoints.endSession(sessionId), isProtected: true);
      });
}
