import 'dart:async';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/lessons_management/data/models/course_schedule_payloads.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_models.dart';
import 'package:bnan_app/features/lessons_management/data/models/gulf_schedule_request.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:dartz/dartz.dart';

class FakeGulfScheduleRepo implements GulfScheduleRepo {
  FakeGulfScheduleRepo({List<GulfClassroom>? classrooms})
    : classrooms = classrooms ?? [];

  List<GulfClassroom> classrooms;
  Failure? loadFailure, saveFailure;
  String? lastOperation, lastClassroomId, lastStudentId;
  CourseScheduleResponse? courseScheduleResponse;
  CourseScheduleUpdateRequest? lastCourseScheduleUpdate;
  String? lastDeletedSlotId;
  GulfScheduleRequest? lastRequest;
  int loadCalls = 0;
  final studentIds = <String?>[];
  Completer<void>? loadGate;
  final queuedLoads = <Completer<Either<Failure, GulfSchedulesResponse>>>[];

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getMyGulfSchedule({
    String? studentId,
  }) async {
    loadCalls++;
    lastStudentId = studentId;
    studentIds.add(studentId);
    if (queuedLoads.isNotEmpty) return queuedLoads.removeAt(0).future;
    await loadGate?.future;
    if (loadFailure != null) return Left(loadFailure!);
    return Right(
      GulfSchedulesResponse(
        success: true,
        data: GulfSchedulesData(classrooms: classrooms),
      ),
    );
  }

  @override
  Future<Either<Failure, GulfSchedulesResponse>> getParentGulfSchedule({
    required String studentId,
  }) => getMyGulfSchedule(studentId: studentId);

  @override
  void invalidateScheduleCache() {}

  @override
  Future<Either<Failure, Unit>> createClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save('post', classroomId, request);

  @override
  Future<Either<Failure, Unit>> updateClassroomSchedule(
    String classroomId,
    GulfScheduleRequest request,
  ) => _save('put', classroomId, request);

  @override
  Future<Either<Failure, Unit>> deleteClassroomSchedule(String classroomId) =>
      _save('delete', classroomId, null);

  @override
  Future<Either<Failure, CourseScheduleResponse>> getCourseSchedule(
    String classroomId,
  ) async {
    lastClassroomId = classroomId;
    if (loadFailure != null) return Left(loadFailure!);
    return Right(
      courseScheduleResponse ??
          const CourseScheduleResponse(
            success: true,
            timezone: 'Africa/Cairo',
            slots: [],
          ),
    );
  }

  @override
  Future<Either<Failure, Unit>> updateCourseSchedule(
    String classroomId,
    CourseScheduleUpdateRequest request,
  ) async {
    lastOperation = 'put_course_schedule';
    lastClassroomId = classroomId;
    lastCourseScheduleUpdate = request;
    if (saveFailure != null) return Left(saveFailure!);
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> deleteCourseScheduleSlot(
    String classroomId,
    String slotId,
  ) async {
    lastOperation = 'delete_course_slot';
    lastClassroomId = classroomId;
    lastDeletedSlotId = slotId;
    if (saveFailure != null) return Left(saveFailure!);
    return const Right(unit);
  }

  Future<Either<Failure, Unit>> _save(
    String operation,
    String classroomId,
    GulfScheduleRequest? request,
  ) async {
    lastOperation = operation;
    lastClassroomId = classroomId;
    lastRequest = request;
    if (saveFailure != null) return Left(saveFailure!);
    classrooms = classrooms
        .map((item) {
          if (item.id != classroomId) return item;
          return GulfClassroom(
            id: item.id,
            name: item.name,
            grade: item.grade,
            curriculum: item.curriculum,
            subject: item.subject,
            classroomSubject: item.classroomSubject,
            schedule: request == null
                ? null
                : GulfSchedule(
                    id: item.schedule?.id ?? 'schedule-new',
                    classroomSubject: request.classroomSubject,
                    entries: request.schedule,
                    isActive: true,
                  ),
          );
        })
        .toList(growable: false);
    return const Right(unit);
  }
}

GulfClassroom gulfClassroom({
  String id = 'class-1',
  String? classroomSubject = 'classroom-subject-1',
  List<GulfScheduleEntry>? entries,
  bool withSchedule = true,
}) => GulfClassroom(
  id: id,
  name: 'Class A',
  subject: const GulfSubject(id: 'subject-1', name: 'Math'),
  classroomSubject: withSchedule ? null : classroomSubject,
  schedule: withSchedule
      ? GulfSchedule(
          id: 'schedule-1',
          classroomSubject: classroomSubject ?? '',
          entries: entries ?? const [],
          isActive: true,
        )
      : null,
);
