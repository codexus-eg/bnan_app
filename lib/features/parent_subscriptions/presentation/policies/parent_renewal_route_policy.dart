import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/subscription_renewal_eligibility.dart';

bool isValidParentRenewalRoute({required String? studentId, Object? extra}) =>
    studentId?.isNotEmpty == true &&
    extra is ParentSubscriptionRenewalArgs &&
    extra.isParent &&
    extra.curriculumId.trim().isNotEmpty &&
    canOpenSubscriptionRenewal(extra) &&
    extra.studentId == studentId;

bool isValidStudentRenewalRoute(Object? extra) =>
    extra is ParentSubscriptionRenewalArgs &&
    !extra.isParent &&
    extra.curriculumId.trim().isNotEmpty &&
    canOpenSubscriptionRenewal(extra);

bool canOpenSubscriptionRenewal(ParentSubscriptionRenewalArgs args) =>
    SubscriptionRenewalEligibility.canRenew(
      args.subscription,
      registrationMode: args.registrationMode,
    );
