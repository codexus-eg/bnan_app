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
}
