import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:dartz/dartz.dart';

class GulfScheduleRepoImpl implements GulfScheduleRepo {
  const GulfScheduleRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule() =>
      repoGuard(() async {
        final response = await api.get(
          EndPoints.myGulfSchedule,
          isProtected: true,
        );
        return GulfSchedulesResponse.fromJson(asMap(response));
      });

  @override
  Future<Either<Failure, Unit>> createClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save(
    () => api.post(
      EndPoints.gulfScheduleByClassroom(classroomId),
      data: request.toJson(),
      isProtected: true,
    ),
  );

  @override
  Future<Either<Failure, Unit>> updateClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save(
    () => api.put(
      EndPoints.gulfScheduleByClassroom(classroomId),
      data: request.toJson(),
      isProtected: true,
    ),
  );

  @override
  Future<Either<Failure, Unit>> deleteClassroomSchedule(String classroomId) =>
      _save(
        () => api.delete(
          EndPoints.gulfScheduleByClassroom(classroomId),
          isProtected: true,
        ),
      );

  Future<Either<Failure, Unit>> _save(Future<Object?> Function() call) =>
      repoGuard(() async {
        await call();
        return unit;
      });
}
