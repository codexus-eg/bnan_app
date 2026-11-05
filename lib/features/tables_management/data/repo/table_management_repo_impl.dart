import 'dart:io';

import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
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
        queryParameter: {
          if (id != null && id.isNotEmpty) 'studentId': id,
        },
        isProtected: true,
      );
      return EgyptianSchedulesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, EgyptianScheduleWeek>>
  getMyEgyptianDigitalSchedule() => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.myEgyptianSchedule,
      isProtected: true,
    );
    return EgyptianScheduleWeek.fromResponse(response);
  });

  @override
  Future<Either<Failure, EgyptianScheduleWeek>> getParentEgyptianSchedule({
    required String studentId,
  }) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.myEgyptianSchedule,
      queryParameter: {
        'studentId': studentId.trim(),
      },
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
    String classroomId,
  ) => repoGuard(() async {
    final response = await apiConsumer.get(
      EndPoints.egyptianSchedulesByClassroom(classroomId.trim()),
      isProtected: true,
    );
    return EgyptianScheduleWeek.fromResponse(response);
  });

  @override
  Future<Either<Failure, UnifiedScheduleMutationData>>
  saveClassroomScheduleEntry({
    required String classroomId,
    required UnifiedScheduleEntryInput entry,
  }) => repoGuard(() async {
    final response = await apiConsumer.put(
      EndPoints.classroomSchedule(classroomId.trim()),
      data: entry.toJson(),
      isProtected: true,
    );
    return UnifiedScheduleMutationResponse.fromJson(asMap(response)).data;
  });

  @override
  Future<Either<Failure, void>> deleteClassroomScheduleEntry({
    required String classroomId,
    required String entryId,
  }) => repoGuard(() async {
    await apiConsumer.delete(
      EndPoints.classroomScheduleEntry(classroomId.trim(), entryId.trim()),
      isProtected: true,
    );
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
      EndPoints.egyptianScheduleDay(classroomId.trim(), request.day.toLowerCase()),
      data: request.replaceJson(),
      isProtected: true,
    );
  });

  @override
  Future<Either<Failure, void>> deleteEgyptianDay({
    required String classroomId,
    required String day,
  }) => repoGuard(() async {
    await apiConsumer.delete(
      EndPoints.egyptianScheduleDay(classroomId.trim(), day.trim().toLowerCase()),
      isProtected: true,
    );
  });
}
