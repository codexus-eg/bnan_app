import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:bnan_app/features/ideal_student/data/repos/ideal_student_repo.dart';

class IdealStudentRepoImpl implements IdealStudentRepo {
  const IdealStudentRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getWeeklyRanking({
    required String classroomId,
    required int page,
    required int limit,
  }) => repoGuard(() async {
    final response = await api.get(
      EndPoints.egyptianWeeklyRankings(classroomId),
      queryParameter: {'page': page, 'limit': limit},
      isProtected: true,
    );
    return IdealStudentRankingResponse.fromJson(asMap(response));
  });
}
