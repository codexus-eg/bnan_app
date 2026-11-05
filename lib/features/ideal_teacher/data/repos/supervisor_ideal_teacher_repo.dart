import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:dartz/dartz.dart';

abstract class SupervisorIdealTeacherRepo {
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers();

  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  });

  Future<Either<Failure, TeacherRankingResponse>> getRanking({
    required String classroomId,
    int page = 1,
    int limit = 20,
  }) async => right(const TeacherRankingResponse());

  Future<Either<Failure, Unit>> addPointAdjustment({
    required String classroomId,
    required String teacherId,
    required int points,
    required String category,
    required String reason,
  }) async => right(unit);

  Future<Either<Failure, List<PointAdjustmentModel>>> getPointAdjustments({
    required String classroomId,
    String? teacherId,
  }) async => right(const []);

  Future<Either<Failure, Unit>> revokePointAdjustment({
    required String classroomId,
    required String adjustmentId,
  }) async => right(unit);
}
