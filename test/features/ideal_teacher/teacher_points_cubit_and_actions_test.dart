import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SupervisorIdealTeacherCubit Points & Ranking operations', () {
    test('selectClassroom triggers getRanking for that classroom', () async {
      final repo = _TestRepo();
      final cubit = SupervisorIdealTeacherCubit(repo);

      await cubit.selectClassroom(
        const PlanClassroomOption(id: 'cls_A', name: 'Classroom A'),
      );

      expect(repo.lastRankingClassroomId, 'cls_A');
      expect(cubit.state.ranking.length, 1);
      expect(cubit.state.status, SupervisorIdealTeacherStatus.loaded);
    });

    test('addPointAdjustment calls repo and refreshes ranking', () async {
      final repo = _TestRepo();
      final cubit = SupervisorIdealTeacherCubit(repo);

      await cubit.selectClassroom(
        const PlanClassroomOption(id: 'cls_A', name: 'Classroom A'),
      );
      repo.lastRankingClassroomId = null;

      final success = await cubit.addPointAdjustment(
        teacherId: 't_1',
        points: 3,
        category: 'effort',
        reason: 'التزام متميز',
      );

      expect(success, isTrue);
      expect(repo.lastAddClassroomId, 'cls_A');
      expect(repo.lastAddTeacherId, 't_1');
      expect(repo.lastAddPoints, 3);
      expect(repo.lastAddCategory, 'effort');
      expect(repo.lastAddReason, 'التزام متميز');
      // Verify refresh was triggered
      expect(repo.lastRankingClassroomId, 'cls_A');
    });

    test('loadPointAdjustments loads history into state', () async {
      final repo = _TestRepo();
      final cubit = SupervisorIdealTeacherCubit(repo);

      await cubit.selectClassroom(
        const PlanClassroomOption(id: 'cls_A', name: 'Classroom A'),
      );

      await cubit.loadPointAdjustments('t_1');

      expect(repo.lastHistoryClassroomId, 'cls_A');
      expect(repo.lastHistoryTeacherId, 't_1');
      expect(cubit.state.adjustments.length, 1);
      expect(cubit.state.adjustments.first.points, 4);
    });

    test('revokePointAdjustment calls repo, reloads history and refreshes ranking', () async {
      final repo = _TestRepo();
      final cubit = SupervisorIdealTeacherCubit(repo);

      await cubit.selectClassroom(
        const PlanClassroomOption(id: 'cls_A', name: 'Classroom A'),
      );
      repo.lastRankingClassroomId = null;

      final success = await cubit.revokePointAdjustment(
        adjustmentId: 'adj_99',
        teacherId: 't_1',
      );

      expect(success, isTrue);
      expect(repo.lastRevokeClassroomId, 'cls_A');
      expect(repo.lastRevokeAdjustmentId, 'adj_99');
      // Verify history and ranking refreshed
      expect(repo.lastHistoryTeacherId, 't_1');
      expect(repo.lastRankingClassroomId, 'cls_A');
    });

    test('submitIdealTeachers sends selected teachers and signer name', () async {
      final repo = _TestRepo();
      final cubit = SupervisorIdealTeacherCubit(repo);

      cubit.selectTeacher('t_1');
      cubit.selectTeacher('t_2');
      expect(cubit.state.selectedTeacherIds, {'t_1', 't_2'});

      await cubit.submitIdealTeachers(signerName: 'مشرف المادة');

      expect(repo.issuedTeacherIds, ['t_1', 't_2']);
      expect(repo.issuedSignerName, 'مشرف المادة');
      expect(cubit.state.selectedTeacherIds, isEmpty);
      expect(cubit.state.status, SupervisorIdealTeacherStatus.success);
    });

    test('getRanking with EGYPTIAN_CLASSROOM_ONLY marks isEgyptianOnlyClassroom true', () async {
      final repo = _TestRepo(
        rankingFailure: Failure(
          message: 'هذه الميزة متاحة للفصول التابعة للنظام المصري فقط',
          code: 'EGYPTIAN_CLASSROOM_ONLY',
          statusCode: 403,
        ),
      );
      final cubit = SupervisorIdealTeacherCubit(repo);

      await cubit.selectClassroom(
        const PlanClassroomOption(id: 'cls_gulf', name: 'أحمد - لغتي'),
      );

      expect(cubit.state.status, SupervisorIdealTeacherStatus.failure);
      expect(cubit.state.isEgyptianOnlyClassroom, isTrue);
    });
  });
}

class _TestRepo extends SupervisorIdealTeacherRepo {
  _TestRepo({this.rankingFailure});
  final Failure? rankingFailure;
  String? lastRankingClassroomId;
  String? lastAddClassroomId;
  String? lastAddTeacherId;
  int? lastAddPoints;
  String? lastAddCategory;
  String? lastAddReason;
  String? lastHistoryClassroomId;
  String? lastHistoryTeacherId;
  String? lastRevokeClassroomId;
  String? lastRevokeAdjustmentId;
  List<String>? issuedTeacherIds;
  String? issuedSignerName;

  @override
  Future<Either<Failure, List<SupervisorTeacherModel>>> getTeachers() async =>
      right(const []);

  @override
  Future<Either<Failure, TeacherRankingResponse>> getRanking({
    required String classroomId,
    int page = 1,
    int limit = 20,
  }) async {
    lastRankingClassroomId = classroomId;
    if (rankingFailure != null) return left(rankingFailure!);
    return right(
      TeacherRankingResponse(
        classroomId: classroomId,
        ranking: [
          const TeacherRankingItemModel(
            rank: 1,
            teacherId: 't_1',
            fullName: 'Teacher 1',
            weeklyPoints: 85,
          ),
        ],
        page: page,
        pages: 1,
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> addPointAdjustment({
    required String classroomId,
    required String teacherId,
    required int points,
    required String category,
    required String reason,
  }) async {
    lastAddClassroomId = classroomId;
    lastAddTeacherId = teacherId;
    lastAddPoints = points;
    lastAddCategory = category;
    lastAddReason = reason;
    return right(unit);
  }

  @override
  Future<Either<Failure, List<PointAdjustmentModel>>> getPointAdjustments({
    required String classroomId,
    String? teacherId,
  }) async {
    lastHistoryClassroomId = classroomId;
    lastHistoryTeacherId = teacherId;
    return right([
      const PointAdjustmentModel(
        id: 'adj_1',
        teacherId: 't_1',
        points: 4,
        category: 'effort',
        reason: 'ممتاز',
        isActive: true,
      ),
    ]);
  }

  @override
  Future<Either<Failure, Unit>> revokePointAdjustment({
    required String classroomId,
    required String adjustmentId,
  }) async {
    lastRevokeClassroomId = classroomId;
    lastRevokeAdjustmentId = adjustmentId;
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> issueIdealTeachers({
    required List<String> teacherIds,
    String? signerName,
  }) async {
    issuedTeacherIds = teacherIds;
    issuedSignerName = signerName;
    return right(unit);
  }
}
