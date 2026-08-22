import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/admin_subscription_renewals/data/models/admin_renewal_status.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_cubit.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/manager/admin_subscription_renewals_state.dart';
import 'package:bnan_app/features/admin_subscription_renewals/presentation/widgets/admin_renewal_reject_dialog.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminRenewalActions extends StatelessWidget {
  const AdminRenewalActions({
    super.key,
    required this.id,
    required this.status,
  });
  final String id;
  final AdminRenewalStatus status;

  @override
  Widget build(BuildContext context) {
    if (status != AdminRenewalStatus.pending &&
        status != AdminRenewalStatus.confirmed) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<
      AdminSubscriptionRenewalsCubit,
      AdminSubscriptionRenewalsState
    >(
      builder: (context, state) {
        final loading = state.processingPaymentId == id;
        return Row(
          children: [
            Expanded(
              child: RegistrationFilledButton(
                title: status == AdminRenewalStatus.pending
                    ? S.of(context).renewalConfirmPayment
                    : S.of(context).renewalApprove,
                color: ColorManager.orangeF9,
                icon: Icons.check,
                isLoading: loading,
                onPressed: () => status == AdminRenewalStatus.pending
                    ? context.read<AdminSubscriptionRenewalsCubit>().confirm(id)
                    : context.read<AdminSubscriptionRenewalsCubit>().approve(
                        id,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            StatusActionButton(
              isLoading: loading,
              onPressed: () => _reject(context),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reject(BuildContext context) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const AdminRenewalRejectDialog(),
    );
    if (reason != null && context.mounted) {
      await context.read<AdminSubscriptionRenewalsCubit>().reject(
        id,
        reason: reason,
      );
    }
  }
}
