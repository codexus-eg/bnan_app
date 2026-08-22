import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/data/repo/attendance_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class AttendanceRepoImpl implements AttendanceRepo {
  const AttendanceRepoImpl(this.api);
  final ApiConsumer api;

  @override
  Future<Either<Failure, List<AttendanceClassroom>>> getAllowedClassrooms(
    UserRole role,
  ) => _guard(() async {
    final path = role == UserRole.teacher
        ? EndPoints.teacherClassrooms
        : EndPoints.supervisorMyClassrooms;
    final response = await api.get(path, isProtected: true);
    var classrooms = _items(response)
        .map(AttendanceClassroom.fromJson)
        .where((item) => item.id.isNotEmpty)
        .toList();
    if (role == UserRole.teacher) {
      classrooms = await _mapTeacherClassroomsToGrades(classrooms);
    }
    debugPrint('ATTENDANCE CLASSROOMS COUNT: ${classrooms.length}');
    for (final classroom in classrooms) {
      debugPrint('ATTENDANCE CLASSROOM ID: ${classroom.id}');
      debugPrint('ATTENDANCE CLASSROOM NAME: ${classroom.name}');
    }
    return classrooms;
  });

  Future<List<AttendanceClassroom>> _mapTeacherClassroomsToGrades(
    List<AttendanceClassroom> allowedClassrooms,
  ) async {
    final curriculumResponse = await api.get(
      EndPoints.teacherCurriculums,
      isProtected: true,
    );
    final grades = <String, AttendanceGrade>{};
    for (final curriculumId in _teacherCurriculumIds(curriculumResponse)) {
      final response = await api.get(
        EndPoints.teacherGrades(curriculumId),
        isProtected: true,
      );
      for (final item in _items(response)) {
        final id = _text(item['id'] ?? item['_id']);
        if (id.isNotEmpty) {
          grades[id] = AttendanceGrade(id: id, name: _text(item['name']));
        }
      }
    }

    final allowedById = {for (final item in allowedClassrooms) item.id: item};
    final mapped = <String, AttendanceClassroom>{};
    for (final grade in grades.values) {
      final response = await api.get(
        EndPoints.gradeClassrooms(grade.id),
        isProtected: true,
      );
      for (final item in _items(response)) {
        final classroomId = AttendanceClassroom.fromJson(item).id;
        final classroom = allowedById[classroomId];
        if (classroom != null) {
          mapped[classroomId] = classroom.withGrade(grade);
        }
      }
    }
    return mapped.values.toList();
  }

  List<String> _teacherCurriculumIds(Object? response) {
    final data = _map(response)['data'];
    if (data is! List) return const [];
    final ids = <String>{};
    for (final item in data.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      final curriculums = map['curriculums'];
      final values = curriculums is List ? curriculums : [map];
      for (final value in values.whereType<Map>()) {
        final curriculum = Map<String, dynamic>.from(value);
        final id = _text(curriculum['id'] ?? curriculum['_id']);
        if (id.isNotEmpty) ids.add(id);
      }
    }
    return ids.toList();
  }

  @override
  Future<Either<Failure, List<AttendanceSession>>> getSessions(
    String classroomId,
  ) => _guard(() async {
    final response = await api.get(
      EndPoints.classroomSessions(classroomId),
      isProtected: true,
    );
    return _items(response, key: 'sessions')
        .map(AttendanceSession.fromJson)
        .where((item) => item.id.isNotEmpty)
        .toList();
  });

  @override
  Future<Either<Failure, List<AttendanceStudent>>> getStudents(
    String classroomId,
  ) => _guard(() async {
    final response = await api.get(
      EndPoints.classroomStudents(classroomId),
      isProtected: true,
    );
    return _items(response, key: 'students')
        .map(AttendanceStudent.fromJson)
        .where((item) => item.id.isNotEmpty)
        .toList();
  });

  @override
  Future<Either<Failure, void>> callStudent(String studentId) =>
      _guard(() async {
        await api.post(
          EndPoints.supervisorCallStudent(studentId),
          data: const <String, dynamic>{},
          isProtected: true,
        );
      });

  @override
  Future<Either<Failure, List<AttendanceRecord>>> submitBulk(
    BulkAttendanceRequest request,
  ) => _guard(() async {
    final response = await api.post(
      EndPoints.bulkAttendance,
      data: request.toJson(),
      isProtected: true,
    );
    return _items(response).map(AttendanceRecord.fromJson).toList();
  });

  @override
  Future<Either<Failure, AttendanceRecord>> create({
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
  }) => _record(
    () => api.post(
      EndPoints.attendance,
      data: {
        'session': sessionId,
        'student': studentId,
        'status': status.apiValue,
      },
      isProtected: true,
    ),
  );
  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAll() => _guard(
    () async => _items(
      await api.get(EndPoints.attendance, isProtected: true),
    ).map(AttendanceRecord.fromJson).toList(),
  );
  @override
  Future<Either<Failure, AttendanceRecord>> getById(String id) =>
      _record(() => api.get(EndPoints.attendanceById(id), isProtected: true));
  @override
  Future<Either<Failure, AttendanceRecord>> update(
    String id,
    AttendanceStatus status,
  ) => _record(
    () => api.patch(
      EndPoints.attendanceById(id),
      data: {'status': status.apiValue},
      isProtected: true,
    ),
  );
  @override
  Future<Either<Failure, void>> delete(String id) => _guard(() async {
    await api.delete(EndPoints.attendanceById(id), isProtected: true);
  });

  Future<Either<Failure, AttendanceRecord>> _record(
    Future<Object?> Function() call,
  ) => _guard(() async {
    final response = await call();
    final map = _map(response);
    return AttendanceRecord.fromJson(
      _map(map['data']).isEmpty ? map : _map(map['data']),
    );
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on AppException catch (error) {
      return Left(
        Failure(
          message: error.message,
          responseReceived: error.responseReceived,
          statusCode: error.statusCode,
          code: error.code,
        ),
      );
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  List<Map<String, dynamic>> _items(Object? response, {String? key}) {
    final data = _map(response)['data'];
    final value = data is Map && key != null ? data[key] : data;
    return value is List
        ? value
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
        : [];
  }

  Map<String, dynamic> _map(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};

  String _text(Object? value) => value?.toString().trim() ?? '';
}
