import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';

class ParentSubscriptionRenewalArgs {
  const ParentSubscriptionRenewalArgs({
    required this.studentId,
    required this.curriculumId,
    required this.subscription,
    required this.subjects,
    required this.registrationMode,
    this.studentName = '',
    this.isParent = true,
  });
  final String studentId, curriculumId, registrationMode;
  final ParentChildSubscriptionModel subscription;
  final List<ParentSubscriptionSubjectModel> subjects;
  final String studentName;
  final bool isParent;
}
