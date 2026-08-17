import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/assign_student_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/available_classrooms_response_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/repo/student_classroom_assignment_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class StudentClassroomAssignmentRepoImpl
    implements StudentClassroomAssignmentRepo {
  const StudentClassroomAssignmentRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, List<UnassignedStudentModel>>>
  getUnassignedStudents() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.unassignedStudents,
        isProtected: true,
      );

      final data = asMap(response)['data'] as List? ?? [];

      return data
          .whereType<Map>()
          .map(
            (item) => UnassignedStudentModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where(
            (student) =>
                student.registrationMode.trim().toLowerCase() == 'egyptian' &&
                student.hasActiveAccount,
          )
          .toList();
    });
  }

  @override
  Future<Either<Failure, AvailableClassroomsResponseModel>>
  getAvailableClassrooms(String studentId) {
    final id = studentId.trim();

    return repoGuard(() async {
      if (id.isEmpty) {
        throw Failure(message: S.current.errorBadRequest);
      }

      final response = await apiConsumer.get(
        EndPoints.availableClassroomsForUnassignedStudent(id),
        isProtected: true,
      );

      return AvailableClassroomsResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, AssignStudentResponseModel>> assignStudent({
    required String studentId,
    required String classroomId,
  }) {
    final student = studentId.trim();
    final classroom = classroomId.trim();

    return repoGuard(() async {
      if (student.isEmpty || classroom.isEmpty) {
        throw Failure(message: S.current.errorBadRequest);
      }

      final response = await apiConsumer.post(
        EndPoints.assignStudentToClassroom,
        data: {'student': student, 'classroom': classroom},
        isProtected: true,
      );

      return AssignStudentResponseModel.fromJson(asMap(response));
    });
  }
}
