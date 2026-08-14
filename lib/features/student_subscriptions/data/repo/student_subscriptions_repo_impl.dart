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
    final home = await api.get(EndPoints.studentHome, isProtected: true);
    final subjectsResponse = await api.get(
      EndPoints.mySubjects,
      isProtected: true,
    );
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
