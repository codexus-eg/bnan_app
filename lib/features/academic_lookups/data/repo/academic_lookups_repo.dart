import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:dartz/dartz.dart';

abstract class AcademicLookupsRepo {
  Future<Either<Failure, List<AcademicCurriculumModel>>> getCurriculums();

  Future<Either<Failure, List<AcademicGradeModel>>> getGrades(
  {  String? curriculumId,}
  );

  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  });

  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  });
}
