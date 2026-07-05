import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/bulk_assign_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class TeacherSubjectAssignmentRepoImpl implements TeacherSubjectAssignmentRepo {
  const TeacherSubjectAssignmentRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>> getTeacherTeachingAssignments() {
    return _guard(() async {
      final response = await apiConsumer.get(
        EndPoints.teachingAssignments,
        isProtected: true,
      );

      return TeachingAssignmentsResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, AssignCurriculumsResponseModel>> assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  }) {
    return _guard(() async {
      final response = await apiConsumer.patch(
        EndPoints.assignCurriculumsToTeacher(teacherId),
        data: {'curriculums': curriculumIds},
        isProtected: true,
      );

      return AssignCurriculumsResponseModel.fromJson(_asMap(response));
    });
  }

  @override
  Future<Either<Failure, BulkAssignTeachingAssignmentsResponseModel>> bulkAssignTeachingAssignments({
    required String teacherId,
    required List<TeachingAssignmentRequestModel> assignments,
  }) {
    return _guard(() async {
      final response = await apiConsumer.post(
        EndPoints.bulkAssignTeachingAssignments(teacherId),
        data: {'assignments': assignments.map((e) => e.toJson()).toList()},
        isProtected: true,
      );

      return BulkAssignTeachingAssignmentsResponseModel.fromJson(_asMap(response));
    });
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Right(await request());
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (error) {
      return Left(Failure(message: error.toString()));
    }
  }

  Map<String, dynamic> _asMap(Object? response) {
    return response is Map ? Map<String, dynamic>.from(response) : {};
  }
}
