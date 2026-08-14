import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';

bool isValidParentRenewalRoute({required String? studentId, Object? extra}) =>
    studentId?.isNotEmpty == true &&
    extra is ParentSubscriptionRenewalArgs &&
    extra.isParent &&
    extra.studentId == studentId;
