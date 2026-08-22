import 'package:bnan_app/core/error/app_exception.dart';
import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_classroom_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';

class AcademicLookupsRepoImpl implements AcademicLookupsRepo {
  const AcademicLookupsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, List<AcademicCurriculumModel>>> getCurriculums() {
    return _guard(() async {
      final response = await apiConsumer.get(EndPoints.curriculums);
      return _dataList(response).map(AcademicCurriculumModel.fromJson).toList();
    });
  }

  @override
  Future<Either<Failure, List<AcademicGradeModel>>> getGrades({
    String? curriculumId,
  }) {
    return _guard(() async {
      final response = await apiConsumer.get(
        curriculumId == null || curriculumId.isEmpty
            ? EndPoints.grades
            : EndPoints.gradesByCurriculum(curriculumId),
      );
      return _dataList(response).map(AcademicGradeModel.fromJson).toList();
    });
  }

  @override
  Future<Either<Failure, List<AcademicClassroomModel>>> getClassroomsByGrade({
    required String curriculumId,
    required String gradeId,
  }) {
    return _guard(() async {
      final response = await apiConsumer.get(
        EndPoints.gradeClassrooms(gradeId),
        isProtected: true,
      );

      return _dataList(response)
          .map(AcademicClassroomModel.fromJson)
          .where((item) => item.id.isNotEmpty)
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<AcademicSubjectModel>>> getSubjects({
    required String curriculumId,
    required String gradeId,
    String? classroomId,
  }) {
    return _guard(() async {
      if (classroomId == null || classroomId.isEmpty) {
        return _getCurriculumSubjects(curriculumId, gradeId);
      }

      final response = await apiConsumer.get(
        EndPoints.classroomSubjectsDetails(classroomId),
        isProtected: true,
      );

      final data = _asMap(response)['data'];
      if (data is! Map) return [];

      final subjects = data['subjects'];
      return subjects is List
          ? subjects
                .whereType<Map<String, dynamic>>()
                .map(AcademicSubjectModel.fromJson)
                .where((item) => item.id.isNotEmpty)
                .toList()
          : [];
    });
  }

  @override
  Future<Either<Failure, Unit>> addClassroomSubject({
    required String classroomId,
    required String subjectId,
  }) => _guard(() async {
    await apiConsumer.post(
      EndPoints.classroomSubjectsRoot,
      data: {'classroom': classroomId, 'subject': subjectId},
      isProtected: true,
    );
    return unit;
  });

  Future<List<AcademicSubjectModel>> _getCurriculumSubjects(
    String curriculumId,
    String gradeId,
  ) async {
    final response = await apiConsumer.get(EndPoints.gradeSubjects(gradeId));
    return _dataList(response).map(AcademicSubjectModel.fromJson).toList();
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Right(await request());
    } on AppException catch (error) {
      return Left(Failure(message: error.message));
    } catch (_) {
      return Left(Failure(message: S.current.unexpectedError));
    }
  }

  List<Map<String, dynamic>> _dataList(Object? response) {
    final data = _asMap(response)['data'];
    return data is List ? data.whereType<Map<String, dynamic>>().toList() : [];
  }

  Map<String, dynamic> _asMap(Object? response) {
    return response is Map ? Map<String, dynamic>.from(response) : {};
  }
}
