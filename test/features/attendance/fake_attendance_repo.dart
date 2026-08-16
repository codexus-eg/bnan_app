import 'dart:async';

import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:dartz/dartz.dart';

class FakeAttendanceRepo implements AttendanceRepo {
  Either<Failure, List<AttendanceClassroom>> classrooms = const Right([]);
  Either<Failure, List<AttendanceStudent>> students = const Right([]);
  Either<Failure, List<AttendanceRecord>> submitResult = const Right([]);
  Completer<Either<Failure, List<AttendanceRecord>>>? submitCompleter;
  final Map<String, Completer<Either<Failure, List<AttendanceSession>>>>
  pendingSessions = {};
  final List<Completer<Either<Failure, List<AttendanceStudent>>>>
  pendingStudents = [];
  bool deferStudents = false;
  BulkAttendanceRequest? submitted;

  @override
  Future<Either<Failure, List<AttendanceClassroom>>> getAllowedClassrooms(
    UserRole role,
  ) async => classrooms;
  @override
  Future<Either<Failure, List<AttendanceStudent>>> getStudents(
    String classroomId,
  ) async {
    if (!deferStudents) return students;
    final completer = Completer<Either<Failure, List<AttendanceStudent>>>();
    pendingStudents.add(completer);
    return completer.future;
  }

  @override
  Future<Either<Failure, void>> callStudent(String studentId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<AttendanceSession>>> getSessions(
    String classroomId,
  ) => pendingSessions.putIfAbsent(classroomId, Completer.new).future;
  @override
  Future<Either<Failure, List<AttendanceRecord>>> submitBulk(
    BulkAttendanceRequest request,
  ) async {
    submitted = request;
    return submitCompleter?.future ?? submitResult;
  }

  @override
  Future<Either<Failure, AttendanceRecord>> create({
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
  }) => throw UnimplementedError();
  @override
  Future<Either<Failure, void>> delete(String id) => throw UnimplementedError();
  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAll() =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, AttendanceRecord>> getById(String id) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, AttendanceRecord>> update(
    String id,
    AttendanceStatus status,
  ) => throw UnimplementedError();
}
