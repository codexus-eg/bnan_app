import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_parser.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:bnan_app/features/ideal_teacher/data/repos/supervisor_ideal_teacher_repo.dart';
import 'package:dartz/dartz.dart';

class SupervisorIdealTeacherRepoImpl implements SupervisorIdealTeacherRepo {
  const SupervisorIdealTeacherRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getTeachers() => repoGuard(() async {
    final isAdmin = SessionManager.instance.role == UserRole.admin;
    dynamic response;
    if (isAdmin) {
      try {
        response = await api.get(
          EndPoints.teachingAssignments,
          isProtected: true,
        );
      } catch (_) {
        response = await api.get(
          EndPoints.users,
          queryParameter: {'role': 'teacher', 'page': 1, 'limit': 100},
          isProtected: true,
        );
      }
    } else {
      response = await api.get(
        EndPoints.supervisorTeachers,
        isProtected: true,
      );
    }
    final rawList = response is List
        ? response
        : (response is Map && response['data'] is List
            ? response['data'] as List
            : IdealTeacherParser.responseItems(response));
    final teachers = rawList
        .map(SupervisorTeacherModel.fromJson)
        .where((teacher) => teacher.id.isNotEmpty)
        .toList(growable: false);

    final seen = <String>{};
    final deduplicated = <SupervisorTeacherModel>[];
    for (final teacher in teachers) {
      if (seen.add(teacher.id)) {
        deduplicated.add(teacher);
      }
    }
    return deduplicated;
  });

  @override
  issueIdealTeachers({required List<String> teacherIds, String? signerName}) =>
      repoGuard(() async {
        final name = signerName?.trim();
        final payload = <String, dynamic>{
          if (teacherIds.length == 1)
            'teacherId': teacherIds.first
          else
            'teacherIds': teacherIds,
          if (name?.isNotEmpty == true) 'signerName': name,
        };
        await api.post(
          EndPoints.supervisorIdealTeachers,
          data: payload,
          isProtected: true,
        );
        return unit;
      });

  @override
  getRanking({required String classroomId, int page = 1, int limit = 20}) =>
      repoGuard(() async {
        final response = await api.get(
          EndPoints.classroomIdealTeacher(classroomId),
          queryParameter: {'page': page, 'limit': limit},
          isProtected: true,
        );
        return TeacherRankingResponse.fromJson(
          IdealTeacherParser.map(response),
        );
      });

  @override
  addPointAdjustment({
    required String classroomId,
    required String teacherId,
    required int points,
    required String category,
    required String reason,
  }) => repoGuard(() async {
    await api.post(
      EndPoints.classroomIdealTeacherPointAdjustments(classroomId),
      data: {
        'teacherId': teacherId,
        'points': points,
        'category': category,
        'reason': reason,
      },
      isProtected: true,
    );
    return unit;
  });

  @override
  getPointAdjustments({required String classroomId, String? teacherId}) =>
      repoGuard(() async {
        final response = await api.get(
          EndPoints.classroomIdealTeacherPointAdjustments(classroomId),
          queryParameter: {
            if (teacherId != null && teacherId.isNotEmpty)
              'teacherId': teacherId,
          },
          isProtected: true,
        );
        final map = IdealTeacherParser.map(response);
        final list = response is List
            ? response
            : map['data'] is List
            ? map['data'] as List
            : map['adjustments'] is List
            ? map['adjustments'] as List
            : const [];
        return list
            .whereType<Map>()
            .map((item) => PointAdjustmentModel.fromJson(Map<String, dynamic>.from(item)))
            .toList(growable: false);
      });

  @override
  revokePointAdjustment({
    required String classroomId,
    required String adjustmentId,
  }) => repoGuard(() async {
    await api.delete(
      EndPoints.classroomIdealTeacherPointAdjustment(classroomId, adjustmentId),
      isProtected: true,
    );
    return unit;
  });
}

