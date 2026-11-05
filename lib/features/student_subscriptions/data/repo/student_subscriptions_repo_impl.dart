import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';

class StudentSubscriptionsRepoImpl implements StudentSubscriptionsRepo {
  const StudentSubscriptionsRepoImpl(this.api);
  final ApiConsumer api;

  Future<dynamic> _fetchHomeOrFallback() async {
    try {
      return await api.get(EndPoints.studentHome, isProtected: true);
    } catch (_) {
      try {
        final subResponse = await api.get(
          EndPoints.studentSubscription,
          isProtected: true,
        );
        if (subResponse is Map && subResponse['data'] is Map) {
          final data = Map<String, dynamic>.from(subResponse['data'] as Map);
          if (data['subscriptions'] is List &&
              (data['subscriptions'] as List).isNotEmpty) {
            return subResponse;
          }
        }
      } catch (_) {}
      return await api.get(EndPoints.dashboard, isProtected: true);
    }
  }

  @override
  getHomeSubscriptions() => repoGuard(() async {
    final home = await _fetchHomeOrFallback();
    return ParentChildSubscriptionsModel.fromStudentHome(
      Map<String, dynamic>.from(home as Map),
    );
  });

  @override
  getSubscriptions() => repoGuard(() async {
    final responses = await Future.wait<dynamic>([
      _fetchHomeOrFallback(),
      api.get(EndPoints.mySubjects, isProtected: true),
    ], eagerError: true);
    final home = responses[0];
    final subjectsResponse = responses[1];
    final subjects = StudentSubjectModel.listFromResponse(subjectsResponse)
        .map(
          (item) =>
              ParentSubscriptionSubjectModel(id: item.id, name: item.name),
        )
        .toList(growable: false);
    return ParentChildSubscriptionsModel.fromStudentHome(
      Map<String, dynamic>.from(home as Map),
      subjects: subjects,
    );
  });

  @override
  getStudentSubscription() => repoGuard(() async {
    final response = await api.get(
      EndPoints.studentSubscription,
      isProtected: true,
    );
    final data = response is Map && response['data'] is Map
        ? Map<String, dynamic>.from(response['data'] as Map)
        : <String, dynamic>{};
    return ParentChildSubscriptionModel.fromJson(data);
  });
}
