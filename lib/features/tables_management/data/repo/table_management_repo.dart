import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class TableManagementRepo {
  Future<Either<Failure, EgyptianSchedulesResponseModel>> getEgyptianSchedules({
    String? gradeId,
  });

  Future<Either<Failure, EgyptianScheduleResponseModel>>
  getEgyptianScheduleByClassroom(String classroomId);

  Future<Either<Failure, EgyptianScheduleResponseModel>>
  createEgyptianSchedule({
    required String classroomId,
    required File scheduleImage,
  });

  Future<Either<Failure, void>> deleteEgyptianSchedule(String scheduleId);
}
