import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assign_curriculums_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/bulk_assign_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignments_response_model.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/teaching_assignment_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class TeacherSubjectAssignmentRepo {
  Future<Either<Failure, TeachingAssignmentsResponseModel>> getTeacherTeachingAssignments();

  Future<Either<Failure, AssignCurriculumsResponseModel>> assignCurriculumsToTeacher({
    required String teacherId,
    required List<String> curriculumIds,
  });

  Future<Either<Failure, BulkAssignTeachingAssignmentsResponseModel>> bulkAssignTeachingAssignments({
    required String teacherId,
    required List<TeachingAssignmentRequestModel> assignments,
  });
}
