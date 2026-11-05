import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:bnan_app/features/teacher_home/data/repo/teacher_session_statistics_repo.dart';

class TeacherSessionStatisticsRepoImpl implements TeacherSessionStatisticsRepo {
  const TeacherSessionStatisticsRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getSessionStatistics({String? from, String? to}) => repoGuard(() async {
    final query = <String, dynamic>{
      if (from != null && from.trim().isNotEmpty) 'from': from.trim(),
      if (to != null && to.trim().isNotEmpty) 'to': to.trim(),
    };
    final response = await api.get(
      EndPoints.teacherSessionStatistics,
      queryParameter: query.isEmpty ? null : query,
      isProtected: true,
    );
    return TeacherSessionStatisticsModel.fromResponse(response);
  });
}
