import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/chats/data/models/classroom_recordings_response.dart';
import 'package:bnan_app/features/chats/data/models/classroom_summaries_response.dart';
import 'package:bnan_app/features/chats/data/repo/classroom_documents_repo.dart';

class ClassroomDocumentsRepoImpl implements ClassroomDocumentsRepo {
  const ClassroomDocumentsRepoImpl(this.api);

  final ApiConsumer api;

  @override
  getRecordings(String classroomId) => repoGuard(() async {
    final response = await api.get(
      EndPoints.classroomRecordings(classroomId),
      isProtected: true,
    );
    return ClassroomRecordingsResponse.fromJson(asMap(response));
  });

  @override
  getSummaries(String classroomId) => repoGuard(() async {
    final response = await api.get(
      EndPoints.classroomSummaries(classroomId),
      isProtected: true,
    );
    return ClassroomSummariesResponse.fromJson(asMap(response));
  });
}
