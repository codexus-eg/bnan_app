import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:dartz/dartz.dart';

abstract class StudentSubjectsRepo {
  Future<Either<Failure, List<StudentSubjectModel>>> getMySubjects();
}
