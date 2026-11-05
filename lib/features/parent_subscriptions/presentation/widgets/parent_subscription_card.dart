import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/helper/package_display_formatter.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/subscription_renewal_eligibility.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/package_scope_badge.dart';
import 'package:bnan_app/core/helper/subscription_hours_formatter.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/subscription_hours_summary_row.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/subscription_progress_bar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

final _renewalNavigations = <String>{};

class ParentSubscriptionCard extends StatelessWidget {
  const ParentSubscriptionCard({
    super.key,
    required this.child,
    required this.subscription,
    this.onRenewed,
    this.onRenewalPending,
    this.locallyPending = false,
    this.showRenew = true,
    this.isParent = true,
  });
  final ParentChildSubscriptionsModel child;
  final ParentChildSubscriptionModel subscription;
  final Future<void> Function()? onRenewed;
  final VoidCallback? onRenewalPending;
  final bool locallyPending;
  final bool showRenew;
  final bool isParent;

  @override
  Widget build(BuildContext context) {
    final renderPending =
        showRenew &&
        _isEgyptian &&
        (subscription.hasPendingRenewal || locallyPending);
    final renderRenew =
        showRenew &&
        SubscriptionRenewalEligibility.canRenew(
          subscription,
          registrationMode: child.registrationMode,
        );
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
                      : PackageDisplayFormatter.name(
                          context,
                          subscription.packageName,
                        ),
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ),
              PackageScopeBadge(scope: subscription.accessScope),
            ],
          ),
          if ((subscription.isHoursPlan || subscription.hasPurchasedHours) &&
              subscription.purchasedHours > 0) ...[
            const SizedBox(height: 10),
            SubscriptionHoursSummaryRow(
              purchasedHours: subscription.purchasedHours,
              usedHours: subscription.usedHours,
              remainingHours: subscription.remainingHours,
            ),
            const SizedBox(height: 10),
            SubscriptionProgressBar(
              usedHours: subscription.usedHours,
              totalHours: subscription.purchasedHours,
            ),
          ],
          const SizedBox(height: 10),
          if (subscription.coveredSubjects.isNotEmpty) ...[
            _line(
              context,
              S.of(context).subjects,
              subscription.coveredSubjects.map((s) => s.name).join('، '),
            ),
          ] else if (subscription.subject?.name.trim().isNotEmpty == true) ...[
            _line(context, S.of(context).subjects, subscription.subject!.name),
          ],
          if (_typeLabel(context).isNotEmpty)
            _line(context, S.of(context).packageType, _typeLabel(context)),
          _line(context, S.of(context).packageAccessScope, _scopeLabel(context)),
          if (subscription.effectiveStatus.trim().isNotEmpty)
            _line(context, S.of(context).status, _statusLabel(context)),
          if (subscription.isHoursPlan) ...[
            if (subscription.hasPurchasedHours)
              _line(
                context,
                S.of(context).renewalPurchasedHours,
                SubscriptionHoursFormatter.formatTotalHours(
                  subscription.purchasedHours,
                  context: context,
                ),
              ),
            if (subscription.hasUsedHours)
              _line(
                context,
                S.of(context).renewalUsedHours,
                SubscriptionHoursFormatter.formatHours(
                  subscription.usedHours,
                  context: context,
                  isRemaining: false,
                ),
              ),
            if (subscription.hasRemainingHours)
              _line(
                context,
                S.of(context).renewalRemainingHours,
                SubscriptionHoursFormatter.formatHours(
                  subscription.remainingHours,
                  context: context,
                  isRemaining: true,
                ),
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
          if (renderPending) ...[
            const SizedBox(height: 12),
            Text(
              S.of(context).renewalPendingReview,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
          ] else if (renderRenew) ...[
            const SizedBox(height: 12),
            CustomAppButton(
              text: S.of(context).renewSubscription,
              onPressed: () async {
                if (!SubscriptionRenewalEligibility.canRenew(
                  subscription,
                  registrationMode: child.registrationMode,
                )) {
                  return;
                }
                if (child.registrationMode == null) {
                  showCustomSnackBar(
                    context,
                    S.of(context).parentUnsupportedRegistrationMode,
                    false,
                  );
                  return;
                }
                final navigationKey =
                    '${isParent ? 'parent' : 'student'}:'
                    '${child.studentId}:${subscription.id}';
                if (!_renewalNavigations.add(navigationKey)) return;
                try {
                  final curriculumId = await _resolveCurriculumId(context);
                  if (curriculumId == null || !context.mounted) return;
                  final result = await MyNavigator.goTo<ParentFlowResult>(
                    context,
                    isParent
                        ? Routes.parentSubscriptionRenewalPath(child.studentId)
                        : Routes.studentSubscriptionRenewal,
                    extra: ParentSubscriptionRenewalArgs(
                      studentId: child.studentId,
                      curriculumId: curriculumId,
                      subscription: subscription,
                      subjects: child.subjects,
                      registrationMode: child.registrationMode!,
                      studentName: child.studentName,
                      isParent: isParent,
                      onCompleted: child.registrationMode == 'egyptian'
                          ? null
                          : onRenewed,
                    ),
                  );
                  if (result == ParentFlowResult.pendingReview &&
                      context.mounted) {
                    if (child.registrationMode == 'egyptian') {
                      onRenewalPending?.call();
                      showCustomSnackBar(
                        context,
                        S.of(context).egyptianRenewalRequestSubmitted,
                        true,
                      );
                    }
                    await onRenewed?.call();
                  }
                } finally {
                  _renewalNavigations.remove(navigationKey);
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
      child.registrationMode?.trim().toLowerCase() == 'egyptian';
  String _date(DateTime value) =>
      value.toLocal().toIso8601String().split('T').first;

  String _typeLabel(BuildContext context) {
    final value = subscription.packageType.trim().toLowerCase();
    if (value == 'hours') {
      return S.of(context).packageHoursType;
    }
    if (value == 'monthly') {
      return S.of(context).monthlyPackage;
    }
    return value;
  }

  String _scopeLabel(BuildContext context) =>
      switch (subscription.accessScope.trim().toLowerCase()) {
        'single_subject' => S.of(context).singleSubject,
        'shared_subjects' => S.of(context).sharedSubjects,
        'all_subjects' => S.of(context).allSubjects,
        final value => value.isEmpty ? S.of(context).allSubjects : value,
      };

  String _statusLabel(BuildContext context) =>
      switch (subscription.effectiveStatus.trim().toLowerCase()) {
        'active' => S.of(context).active,
        'grace_period' => S.of(context).active,
        'expired' || 'completed' => S.of(context).finished,
        'pending' => S.of(context).subjectStatusPending,
        final value => value,
      };

  Future<String?> _resolveCurriculumId(BuildContext context) async {
    final current = child.curriculumId.trim();
    if (current.isNotEmpty) return current;
    final packageId = subscription.packageId.trim();
    if (packageId.isEmpty) {
      showCustomSnackBar(context, S.of(context).invalidData, false);
      return null;
    }
    final result = await getIt<PackagesRepo>().getPackageById(packageId);
    if (!context.mounted) return null;
    return result.fold(
      (failure) {
        showCustomSnackBar(context, failure.message, false);
        return null;
      },
      (response) {
        final value = response.data?.curriculum?.trim() ?? '';
        if (value.isNotEmpty) return value;
        showCustomSnackBar(context, S.of(context).invalidData, false);
        return null;
      },
    );
  }
}
