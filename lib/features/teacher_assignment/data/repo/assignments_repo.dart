import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/classroom_subjects_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/create_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/review_assignment_request_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/subject_details_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assignment_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_classrooms_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_curriculum_response_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_grades_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class AssignmentsRepo {
  Future<Either<Failure, TeacherAssignmentsResponseModel>> getAssignments({
    String? status,
  });

  Future<Either<Failure, AssignmentModel>> createAssignment({
    required CreateAssignmentRequestModel request,
  });

  Future<Either<Failure, AssignmentModel>> updateAssignment({
    required String assignmentId,
    required CreateAssignmentRequestModel request,
  });

  Future<Either<Failure, void>> deleteAssignment({
    required String assignmentId,
  });

  Future<Either<Failure, TeacherClassroomsResponseModel>> getMyClassrooms();

  Future<Either<Failure, TeacherCurriculumsResponseModel>> getMyCurriculums();

  Future<Either<Failure, TeacherGradesResponseModel>> getGradesByCurriculum({
    required String curriculumId,
  });

  Future<Either<Failure, void>> reviewSubmission({
    required String assignmentId,
    required String submissionId,
    required ReviewAssignmentRequestModel request,
  });

  Future<Either<Failure, ClassroomSubjectsResponseModel>> getClassroomSubjects({
  required String classroomId,
});

Future<Either<Failure, SubjectDetailsModel>> getSubjectDetails({
  required String subjectId,
});

}