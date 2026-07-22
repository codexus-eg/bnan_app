import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class TableManagementRepoImpl implements TableManagementRepo {
  const TableManagementRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, EgyptianSchedulesResponseModel>> getEgyptianSchedules({
    String? gradeId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.egyptianSchedulesList(gradeId: gradeId),
        isProtected: true,
      );
      return EgyptianSchedulesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, EgyptianScheduleResponseModel>>
  getEgyptianScheduleByClassroom(String classroomId) {
    final id = classroomId.trim();

    return repoGuard(() async {
      if (id.isEmpty) throw Failure(message: S.current.errorBadRequest);

      final response = await apiConsumer.get(
        EndPoints.egyptianSchedulesByClassroom(id),
        isProtected: true,
      );
      return EgyptianScheduleResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, EgyptianScheduleResponseModel>>
  createEgyptianSchedule({
    required String classroomId,
    required File scheduleImage,
  }) {
    final id = classroomId.trim();

    return repoGuard(() async {
      if (id.isEmpty) throw Failure(message: S.current.errorBadRequest);

      final response = await apiConsumer.post(
        EndPoints.egyptianSchedules,
        data: FormData.fromMap({
          'classroom': id,
          'scheduleImage': await MultipartFile.fromFile(
            scheduleImage.path,
            filename: scheduleImage.path.split('/').last,
          ),
        }),
        isProtected: true,
      );
      return EgyptianScheduleResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, void>> deleteEgyptianSchedule(String scheduleId) {
    final id = scheduleId.trim();

    return repoGuard(() async {
      if (id.isEmpty) throw Failure(message: S.current.errorBadRequest);

      await apiConsumer.delete(
        EndPoints.deleteEgyptianSchedule(id),
        isProtected: true,
      );
    });
  }
}
