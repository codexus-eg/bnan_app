import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:dartz/dartz.dart';

abstract class AttendanceRepo {
  Future<Either<Failure, List<AttendanceClassroom>>> getAllowedClassrooms(
    UserRole role,
  );
  Future<Either<Failure, List<AttendanceSession>>> getSessions(
    String classroomId,
  );
  Future<Either<Failure, List<AttendanceStudent>>> getStudents(
    String classroomId,
  );
  Future<Either<Failure, List<AttendanceRecord>>> submitBulk(
    BulkAttendanceRequest request,
  );
  Future<Either<Failure, AttendanceRecord>> create({
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
  });
  Future<Either<Failure, List<AttendanceRecord>>> getAll();
  Future<Either<Failure, AttendanceRecord>> getById(String id);
  Future<Either<Failure, AttendanceRecord>> update(
    String id,
    AttendanceStatus status,
  );
  Future<Either<Failure, void>> delete(String id);
}
