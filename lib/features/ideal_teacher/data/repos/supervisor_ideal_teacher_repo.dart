import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:dartz/dartz.dart';

abstract class SupervisorIdealTeacherRepo {
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers();

  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  });
}
