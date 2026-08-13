import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/package_scope_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentSubscriptionCard extends StatelessWidget {
  const ParentSubscriptionCard({
    super.key,
    required this.child,
    required this.subscription,
    this.onRenewed,
    this.showRenew = true,
  });
  final ParentChildSubscriptionsModel child;
  final ParentChildSubscriptionModel subscription;
  final VoidCallback? onRenewed;
  final bool showRenew;

  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                subscription.packageName.isEmpty
                    ? '-'
                    : subscription.packageName,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
            if (subscription.isSingleSubject) const PackageScopeBadge(),
          ],
        ),
        const SizedBox(height: 10),
        if (subscription.isSingleSubject &&
            subscription.subject?.name.trim().isNotEmpty == true)
          _line(context, S.of(context).subjects, subscription.subject!.name),
        if (subscription.packageType.trim().isNotEmpty)
          _line(context, S.of(context).packageType, subscription.packageType),
        if (subscription.status.trim().isNotEmpty)
          _line(context, S.of(context).status, subscription.status),
        if (subscription.packageType == 'hours') ...[
          _line(
            context,
            S.of(context).renewalPurchasedHours,
            _number(subscription.purchasedHours),
          ),
          _line(
            context,
            S.of(context).renewalUsedHours,
            _number(subscription.usedHours),
          ),
          _line(
            context,
            S.of(context).renewalRemainingHours,
            _number(subscription.remainingHours),
          ),
        ],
        if (subscription.startDate != null)
          _line(
            context,
            S.of(context).startDate,
            _date(subscription.startDate!),
          ),
        if (subscription.endDate != null)
          _line(
            context,
            S.of(context).renewalExpiry,
            _date(subscription.endDate!),
          ),
        if (subscription.price != null)
          _line(
            context,
            S.of(context).packagePrice,
            [
              _number(subscription.price!),
              if (subscription.currency?.trim().isNotEmpty == true)
                subscription.currency!.trim(),
            ].join(' '),
          ),
        if (showRenew &&
            subscription.canRenew &&
            subscription.curriculumId.isNotEmpty) ...[
          const SizedBox(height: 12),
          CustomAppButton(
            text: S.of(context).renewSubscription,
            onPressed: () async {
              final result = await MyNavigator.goTo<ParentFlowResult>(
                context,
                Routes.parentSubscriptionRenewalPath(child.studentId),
                extra: ParentSubscriptionRenewalArgs(
                  studentId: child.studentId,
                  curriculumId: subscription.curriculumId,
                  subscription: subscription,
                  subjects: child.subjects,
                  registrationMode: child.registrationMode ?? '',
                ),
              );
              if (result == ParentFlowResult.completed) onRenewed?.call();
            },
          ),
        ],
      ],
    ),
  );

  Widget _line(BuildContext context, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: StylesManager.styleRegular14(context)),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: StylesManager.styleBold14(context),
          ),
        ),
      ],
    ),
  );
  String _number(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
  String _date(DateTime value) =>
      value.toLocal().toIso8601String().split('T').first;
}
