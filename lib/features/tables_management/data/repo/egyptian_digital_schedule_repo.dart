import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:dartz/dartz.dart';

abstract interface class EgyptianDigitalScheduleRepo {
  Future<Either<Failure, List<EgyptianClassroomSubject>>>
  getEgyptianClassroomSubjects(String classroomId);

  Future<Either<Failure, EgyptianScheduleWeek>> getEgyptianClassroomWeek(
    String classroomId,
  );

  Future<Either<Failure, void>> createEgyptianDay({
    required String classroomId,
    required EgyptianDayRequest request,
  });

  Future<Either<Failure, void>> replaceEgyptianDay({
    required String classroomId,
    required EgyptianDayRequest request,
  });

  Future<Either<Failure, void>> deleteEgyptianDay({
    required String classroomId,
    required String day,
  });
}
