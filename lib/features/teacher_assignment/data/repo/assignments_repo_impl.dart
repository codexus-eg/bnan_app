import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repos_and_cubit_exports.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_submissions_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/classroom_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/create_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/get_teacher_assigned_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/review_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_grades_response_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class AssignmentsRepoImpl implements AssignmentsRepo {
  const AssignmentsRepoImpl({required this.apiConsumer});

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, TeacherAssignmentsResponseModel>> getAssignments({
    String? status,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.assignments,
        queryParameter: status == null ? null : {'status': status},
        isProtected: true,
      );

      return Right(TeacherAssignmentsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, AssignmentModel>> createAssignment({
    required CreateAssignmentRequestModel request,
  }) async {
    try {
      final formData = FormData.fromMap({
        'classroom': request.classroom,
        'subject': request.subject,
        'title': request.title,
        'dueDate': request.dueDate,
        'totalPoints': request.totalPoints,
        if (request.description.trim().isNotEmpty)
          'description': request.description.trim(),
        if (request.attachment != null)
          'attachment': await MultipartFile.fromFile(
            request.attachment!.path,
            filename: request.attachment!.path.split('/').last,
          ),
      });

      final response = await apiConsumer.post(
        EndPoints.assignments,
        data: formData,
        isProtected: true,
      );

      return Right(AssignmentModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, AssignmentModel>> updateAssignment({
    required String assignmentId,
    required CreateAssignmentRequestModel request,
  }) async {
    try {
      final response = await apiConsumer.patch(
        EndPoints.assignmentById(assignmentId),
        data: request.toJson(),
        isProtected: true,
      );

      return Right(AssignmentModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAssignment({
    required String assignmentId,
  }) async {
    try {
      await apiConsumer.delete(
        EndPoints.assignmentById(assignmentId),
        isProtected: true,
      );

      return const Right(null);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, TeacherClassroomsResponseModel>>
  getMyClassrooms() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.teacherClassrooms,
        isProtected: true,
      );

      return Right(TeacherClassroomsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, TeacherCurriculumsResponseModel>>
  getMyCurriculums() async {
    try {
      final response = await apiConsumer.get(
        EndPoints.teacherCurriculums,
        isProtected: true,
      );

      return Right(TeacherCurriculumsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, TeacherGradesResponseModel>> getGradesByCurriculum({
    required String curriculumId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.teacherGrades(curriculumId),
        isProtected: true,
      );

      return Right(TeacherGradesResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, void>> reviewSubmission({
    required String assignmentId,
    required String submissionId,
    required ReviewAssignmentRequestModel request,
  }) async {
    try {
      await apiConsumer.patch(
        EndPoints.reviewSubmission(
          assignmentId: assignmentId,
          submissionId: submissionId,
        ),
        data: request.toJson(),
        isProtected: true,
      );

      return const Right(null);
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, ClassroomSubjectsResponseModel>> getClassroomSubjects({
    required String classroomId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.classroomSubjectsDetails(classroomId),
        isProtected: true,
      );

      return Right(ClassroomSubjectsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, GetTeacherAssignedSubjectsResponseModel>>
  getTeacherAssignedSubjects({required String classroomId}) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.teacherAssignedSubjects,
        queryParameter: {'classroom': classroomId},
        isProtected: true,
      );

      return Right(GetTeacherAssignedSubjectsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, SubjectDetailsModel>> getSubjectDetails({
    required String subjectId,
  }) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.subjectDetails(subjectId),
        isProtected: true,
      );

      return Right(SubjectDetailsModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  @override
  Future<Either<Failure, AssignmentSubmissionsResponseModel>>
  getAssignmentSubmissions({required String assignmentId}) async {
    try {
      final response = await apiConsumer.get(
        EndPoints.assignmentSubmissions(assignmentId),
        isProtected: true,
      );

      return Right(AssignmentSubmissionsResponseModel.fromJson(response));
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }
}
