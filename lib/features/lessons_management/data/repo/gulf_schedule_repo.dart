import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
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
  Future<Either<Failure, CourseScheduleResponse>> getCourseSchedule(
    String classroomId,
  );
  Future<Either<Failure, Unit>> updateCourseSchedule(
    String classroomId,
    CourseScheduleUpdateRequest request,
  );
  Future<Either<Failure, Unit>> deleteCourseScheduleSlot(
    String classroomId,
    String slotId,
  );
}
