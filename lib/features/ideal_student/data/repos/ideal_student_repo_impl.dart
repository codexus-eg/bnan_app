import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:bnan_app/features/ideal_student/data/repos/ideal_student_repo.dart';
import 'package:flutter/foundation.dart';

class IdealStudentRepoImpl implements IdealStudentRepo {
  const IdealStudentRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  }) => repoGuard(() async {
    final endpoint = EndPoints.classroomWeeklyRanking(classroomId);
    if (kDebugMode) {
      debugPrint(
        '[IdealStudentRepo] classroomId=$classroomId '
        'page=$page limit=$limit endpoint=$endpoint',
      );
    }
    final response = await api.get(
      endpoint,
      queryParameter: {'page': page, 'limit': limit},
      isProtected: true,
    );
    final json = asMap(response);
    final value = IdealStudentRankingResponse.fromJson(json);
    if (kDebugMode) {
      debugPrint(
        '[IdealStudentRepo] classroomId=$classroomId '
        'topKeys=${json.keys.toList()} status=${value.status} '
        'ranking=${value.ranking.length} '
        'idealStudentId=${value.idealStudent?.studentId ?? ''} '
        'page=${value.pagination.page}/${value.pagination.pages}',
      );
    }
    return value;
  });
}
