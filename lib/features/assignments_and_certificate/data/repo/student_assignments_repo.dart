import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/models/assignment_model.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/models/submit_assignment_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentAssignmentsRepo {
  Future<Either<Failure, AssignmentsResponseModel>> getMyAssignments();
Future<Either<Failure, SubmitAssignmentResponseModel>> submitAssignment({
  required String assignmentId,
  required String filePath,
});
}