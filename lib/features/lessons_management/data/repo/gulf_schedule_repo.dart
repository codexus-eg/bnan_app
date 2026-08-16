import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:dartz/dartz.dart';

abstract class GulfScheduleRepo {
  void invalidateScheduleCache() {}

  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  });
  Future<Either<Failure, GulfSchedulesResponse>> getParentGulfSchedule({
    required String studentId,
    String? weekStart,
  }) => getMyGulfSchedule(studentId: studentId);
  Future<Either<Failure, Unit>> createClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  );
  Future<Either<Failure, Unit>> updateClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  );
  Future<Either<Failure, Unit>> deleteClassroomSchedule(String classroomId);
}
