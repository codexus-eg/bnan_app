import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/repo/teacher_subject_assignment_repo.dart';
import 'package:dartz/dartz.dart';

class TeacherSubjectAssignmentRepoImpl implements TeacherSubjectAssignmentRepo {
  const TeacherSubjectAssignmentRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments({
    String? keyword,
    String? subject,
  }) {
    return repoGuard(() async {
      final trimmedKeyword = keyword?.trim();
      final trimmedSubject = subject?.trim();
      final response = await apiConsumer.get(
        EndPoints.teachingAssignments,
        queryParameter: {
          if (trimmedKeyword != null && trimmedKeyword.isNotEmpty)
            'teacher': trimmedKeyword,
          if (trimmedSubject != null && trimmedSubject.isNotEmpty)
            'subject': trimmedSubject,
        },
        isProtected: true,
      );

      return TeachingAssignmentsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, AssignCurriculumsResponseModel>>
  assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.assignCurriculumsToTeacher(teacherId),
        data: {'curriculums': curriculumIds},
        isProtected: true,
      );

      return AssignCurriculumsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.put(
        EndPoints.assignTeacher(teacherId),
        data: request.toJson(),
        isProtected: true,
      );

      return AssignTeacherResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  }) {
    return repoGuard(() async {
      final response = await apiConsumer.patch(
        EndPoints.unassignTeacherFromClassroom(
          teacherId: teacherId,
          classroomId: classroomId,
        ),
        isProtected: true,
      );
      return UnassignTeacherResponseModel.fromJson(asMap(response));
    });
  }
}
