import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedule_response_model.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_digital_schedule_models.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/data/repo/egyptian_digital_schedule_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class TableManagementRepoImpl
    implements TableManagementRepo, EgyptianDigitalScheduleRepo {
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
  Future<Either<Failure, EgyptianSchedulesResponseModel>>
  getMyEgyptianSchedule({String? studentId}) {
    final id = studentId?.trim();
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.myEgyptianSchedule,
        queryParameter: id == null || id.isEmpty ? null : {'studentId': id},
        isProtected: true,
      );
      return EgyptianSchedulesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, EgyptianScheduleWeek>> getMyEgyptianDigitalSchedule({
    String? weekStart,
  }) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.myEgyptianSchedule,
      queryParameter: weekStart == null ? null : {'weekStart': weekStart},
      isProtected: true,
    );
    return EgyptianScheduleWeek.fromResponse(response);
  });

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

  @override
  Future<Either<Failure, List<EgyptianClassroomSubject>>>
  getEgyptianClassroomSubjects(String classroomId) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.classroomSubjectsDetails(classroomId.trim()),
      isProtected: true,
    );
    return parseEgyptianClassroomSubjects(asMap(response)['data']);
  });

  @override
  Future<Either<Failure, EgyptianScheduleWeek>> getEgyptianClassroomWeek(
    String classroomId, {
    required String weekStart,
  }) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.egyptianSchedulesByClassroom(classroomId.trim()),
      queryParameter: {'weekStart': weekStart},
      isProtected: true,
    );
    return EgyptianScheduleWeek.fromResponse(response);
  });

  @override
  Future<Either<Failure, void>> createEgyptianDay({
    required String classroomId,
    required EgyptianDayRequest request,
  }) => repoGuard(() async {
    await apiConsumer.post(
      EndPoints.egyptianSchedules,
      data: request.createJson(classroomId.trim()),
      isProtected: true,
    );
  });

  @override
  Future<Either<Failure, void>> replaceEgyptianDay({
    required String classroomId,
    required EgyptianDayRequest request,
  }) => repoGuard(() async {
    await apiConsumer.put(
      EndPoints.egyptianScheduleDay(classroomId.trim(), request.date),
      data: request.replaceJson(),
      isProtected: true,
    );
  });

  @override
  Future<Either<Failure, void>> deleteEgyptianDay({
    required String classroomId,
    required String date,
  }) => repoGuard(() async {
    await apiConsumer.delete(
      EndPoints.egyptianScheduleDay(classroomId.trim(), date.trim()),
      isProtected: true,
    );
  });
}
