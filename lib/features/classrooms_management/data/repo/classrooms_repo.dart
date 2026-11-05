import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_details_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_request_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_subjects_response_model.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classrooms_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class ClassroomsRepo {
  Future<Either<Failure, ClassroomsResponseModel>> getClassrooms({
    int? page,
    int? limit,
    String? curriculum,
    String? keyword,
  });

  Future<Either<Failure, ClassroomDetailsResponseModel>> getClassroomDetails(
    String classroomId,
  );

  Future<Either<Failure, void>> createClassroom(ClassroomRequestModel model);

  Future<Either<Failure, void>> updateClassroom(
    String classroomId,
    ClassroomRequestModel model,
  );

  Future<Either<Failure, void>> deleteClassroom(
    String classroomId, {
    String? reason,
  });

  Future<Either<Failure, ClassroomSubjectsResponseModel>> getClassroomSubjects(
    String classroomId,
  );

  Future<Either<Failure, void>> addClassroomSubject({
    required String classroomId,
    required String subjectId,
    String? teacherId,
  });

  Future<Either<Failure, void>> deleteClassroomSubject({
    required String classroomId,
    required String classroomSubjectId,
  });
}
