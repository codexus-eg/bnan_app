import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_teacher_request_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/unassign_teacher_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherSubjectAssignmentRepo {
  Future<Either<Failure, TeachingAssignmentsResponseModel>>
  getTeacherTeachingAssignments({
    String? keyword,
    String? subject,
  });

  Future<Either<Failure, AssignCurriculumsResponseModel>>
  assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  });

  Future<Either<Failure, AssignTeacherResponseModel>> assignTeacher({
    required String teacherId,
    required AssignTeacherRequestModel request,
  });

  Future<Either<Failure, UnassignTeacherResponseModel>>
  unassignTeacherFromClassroom({
    required String teacherId,
    required String classroomId,
  });
}
