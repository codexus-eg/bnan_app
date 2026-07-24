import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/assign_student_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentClassroomAssignmentRepo {
  Future<Either<Failure, List<UnassignedStudentModel>>>
  getUnassignedStudents();

  Future<Either<Failure, AvailableClassroomsResponseModel>>
  getAvailableClassrooms(String studentId);

  Future<Either<Failure, AssignStudentResponseModel>> assignStudent({
    required String studentId,
    required String classroomId,
  });
}