import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
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
    this.isParent = true,
  });
  final ParentChildSubscriptionsModel child;
  final ParentChildSubscriptionModel subscription;
  final Future<void> Function()? onRenewed;
  final bool showRenew;
  final bool isParent;

  @override
  Widget build(BuildContext context) {
    final renderRenew = showRenew && subscription.canRenew;
    return CustomDetailsWidgetBackground(
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
          if (_typeLabel(context).isNotEmpty)
            _line(context, S.of(context).packageType, _typeLabel(context)),
          if (subscription.effectiveStatus.trim().isNotEmpty)
            _line(context, S.of(context).status, _statusLabel(context)),
          if (subscription.isHoursPlan) ...[
            if (subscription.hasPurchasedHours)
              _line(
                context,
                S.of(context).renewalPurchasedHours,
                _number(subscription.purchasedHours),
              ),
            if (subscription.hasUsedHours)
              _line(
                context,
                S.of(context).renewalUsedHours,
                _number(subscription.usedHours),
              ),
            if (subscription.hasRemainingHours)
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
          if (!_isEgyptian && subscription.price != null)
            _line(
              context,
              S.of(context).adminSubjectRequestPrice,
              [
                _number(subscription.price!),
                if (subscription.currency?.trim().isNotEmpty == true)
                  subscription.currency!.trim(),
              ].join(' '),
            ),
          if (renderRenew) ...[
            const SizedBox(height: 12),
            CustomAppButton(
              text: S.of(context).renewSubscription,
              onPressed: () async {
                final registrationMode = child.registrationMode ?? '';
                final result = await MyNavigator.goTo<ParentFlowResult>(
                  context,
                  isParent
                      ? Routes.parentSubscriptionRenewalPath(child.studentId)
                      : Routes.studentSubscriptionRenewal,
                  extra: ParentSubscriptionRenewalArgs(
                    studentId: child.studentId,
                    curriculumId: subscription.curriculumId,
                    subscription: subscription,
                    subjects: child.subjects,
                    registrationMode: registrationMode,
                    studentName: child.studentName,
                    isParent: isParent,
                    onCompleted: registrationMode == 'egyptian'
                        ? null
                        : onRenewed,
                  ),
                );
                if (registrationMode == 'egyptian' &&
                    result == ParentFlowResult.pendingReview &&
                    context.mounted) {
                  showCustomSnackBar(
                    context,
                    S.of(context).egyptianRenewalRequestSubmitted,
                    true,
                  );
                  await onRenewed?.call();
                }
              },
            ),
          ],
        ],
      ),
    );
  }

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
  bool get _isEgyptian =>
      child.registrationMode?.trim().toLowerCase() == 'egyptian' ||
      subscription.planKind.trim().toLowerCase().startsWith('egyptian');
  String _date(DateTime value) =>
      value.toLocal().toIso8601String().split('T').first;

  String _typeLabel(BuildContext context) {
    final value = subscription.packageType.trim().toLowerCase();
    if (value == 'hours' || subscription.planKind == 'gulf') {
      return S.of(context).packageHoursType;
    }
    if (value == 'monthly' || subscription.planKind == 'egyptian_monthly') {
      return S.of(context).monthlyPackage;
    }
    return value;
  }

  String _statusLabel(BuildContext context) =>
      switch (subscription.effectiveStatus.trim().toLowerCase()) {
        'active' => S.of(context).active,
        'grace_period' => S.of(context).active,
        'expired' || 'completed' => S.of(context).finished,
        final value => value,
      };
}
