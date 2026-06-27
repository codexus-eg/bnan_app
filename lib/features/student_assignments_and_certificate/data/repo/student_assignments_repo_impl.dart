import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/submit_assignment_response_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/repo/student_assignments_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class StudentAssignmentsRepoImpl implements StudentAssignmentsRepo {
  const StudentAssignmentsRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, AssignmentsResponseModel>> getMyAssignments() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.myAssignments,
        isProtected: true,
      );

      return Right(AssignmentsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, SubmitAssignmentResponseModel>> submitAssignment({
    required String assignmentId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'attachment': await MultipartFile.fromFile(filePath),
      });

      final response = await apiConsumer.post(
        EndPoints.submitAssignment(assignmentId),
        data: formData,
        isProtected: true,
      );

      return Right(SubmitAssignmentResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}
