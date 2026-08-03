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
    return _items(response)
        .map(AttendanceClassroom.fromJson)
        .where((item) => item.id.isNotEmpty && item.grade.id.isNotEmpty)
        .toList();
  });

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
      return Left(Failure(message: error.message));
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
}
