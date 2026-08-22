import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/student_subjects/data/models/student_subject_model.dart';
import 'package:bnan_app/features/student_subscriptions/data/repo/student_subscriptions_repo.dart';

class StudentSubscriptionsRepoImpl implements StudentSubscriptionsRepo {
  const StudentSubscriptionsRepoImpl(this.api);
  final ApiConsumer api;

  @override
  getSubscriptions() => repoGuard(() async {
    final responses = await Future.wait<dynamic>([
      api.get(EndPoints.studentHome, isProtected: true),
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
}
