import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_children/data/models/parent_flow_result.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/renewal_status_response.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalResult extends StatelessWidget {
  const RenewalResult({super.key, required this.state});
  final ParentSubscriptionRenewalState state;
  @override
  Widget build(BuildContext context) {
    final completed = state.phase == ParentRenewalPhase.completed;
    final failed = state.phase == ParentRenewalPhase.failure;
    final pending = state.phase == ParentRenewalPhase.pending;
    final unknown = state.phase == ParentRenewalPhase.paymentStatusUnknown;
    final message = completed
        ? S.of(context).renewalCompleted
        : failed
        ? state.errorMessage ?? S.of(context).renewalFailed
        : pending
        ? state.status == RenewalPaymentStatus.confirmed
              ? S.of(context).parentPaymentConfirmedWaiting
              : S.of(context).renewalReceiptPending
        : unknown
        ? S.of(context).parentPaymentStatusTimeout
        : S.of(context).parentPaymentProcessing;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!completed && !failed && !unknown)
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: StylesManager.styleBold16(context),
            ),
            if (state.status != null) ...[
              const SizedBox(height: 8),
              Text(state.status!.name),
            ],
            const SizedBox(height: 24),
            if (completed || pending)
              CustomAppButton(
                text: S.of(context).parentBackToChildren,
                onPressed: () => MyNavigator.pop(
                  context,
                  completed
                      ? ParentFlowResult.completed
                      : ParentFlowResult.pendingReview,
                ),
              ),
            if (unknown) ...[
              CustomAppButton(
                text: S.of(context).parentCheckPaymentStatus,
                onPressed: context
                    .read<ParentSubscriptionRenewalCubit>()
                    .checkPaymentStatus,
              ),
              if (state.checkoutUrl?.isNotEmpty == true) ...[
                const SizedBox(height: 12),
                CustomAppButton(
                  text: S.of(context).parentOpenPaymentPage,
                  onPressed: context
                      .read<ParentSubscriptionRenewalCubit>()
                      .reopenCheckout,
                ),
              ],
            ],
            if (failed)
              CustomAppButton(
                text: S.of(context).parentRetryPayment,
                onPressed: context.read<ParentSubscriptionRenewalCubit>().retry,
              ),
          ],
        ),
      ),
    );
  }
}
