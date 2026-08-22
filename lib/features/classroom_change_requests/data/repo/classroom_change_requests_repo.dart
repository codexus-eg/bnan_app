import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_request_model.dart';
import 'package:bnan_app/features/classroom_change_requests/data/models/classroom_change_requests_page.dart';
import 'package:dartz/dartz.dart';

abstract class ClassroomChangeRequestsRepo {
  Future<Either<Failure, String>> submitStudent({
    required String classroomId,
    String? classroomSubjectId,
    required String notes,
    String requestType = 'change_teacher',
  });
  Future<Either<Failure, String>> submitTeacher({
    required String classroomId,
    required String classroomSubjectId,
    required String notes,
  });
  Future<Either<Failure, ClassroomChangeRequestsPage>> getAdminRequests();
  Future<Either<Failure, ClassroomChangeRequestModel>> getAdminRequest(
    String id,
  );
  Future<Either<Failure, String>> approve(
    String id, {
    required String classroomSubjectId,
    String? adminNotes,
  });
  Future<Either<Failure, String>> reject(
    String id, {
    required String rejectionReason,
  });
}
