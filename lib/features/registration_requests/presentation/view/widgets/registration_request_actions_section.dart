import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/helper/whatsapp_launcher.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_state.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/confirm_registration_payment_dialog.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/payment_review_box.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_outlined_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationRequestActionsSection extends StatelessWidget {
  const RegistrationRequestActionsSection({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      RegistrationRequestActionsCubit,
      RegistrationRequestActionsState
    >(
      listenWhen: (_, state) => _isAccountActionState(state),
      listener: _onAccountActionState,
      builder: (context, _) {
        final s = S.of(context);
        final cubit = context.read<RegistrationRequestActionsCubit>();
        final isCompleted =
            request.registrationStatus == 'approved' ||
            request.registrationStatus == 'rejected';
        final isPaymentConfirmed = request.isPaymentConfirmed;
        final isApproving = cubit.isActionLoading(
          studentId: request.studentId,
          actionType: RegistrationRequestActionType.approve,
        );
        final isRejecting = cubit.isActionLoading(
          studentId: request.studentId,
          actionType: RegistrationRequestActionType.reject,
        );

        return Column(
          children: [
            PaymentReviewBox(request: request),
            if (!isCompleted) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RegistrationFilledButton(
                      title: isPaymentConfirmed
                          ? s.paymentCompleted
                          : s.uploadReceipt,
                      color: ColorManager.secondaryColor,
                      isDisabled: isPaymentConfirmed,
                      onPressed: isPaymentConfirmed
                          ? null
                          : () => _showPaymentDialog(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: RegistrationOutlinedButton(
                      title: s.contactWhatsApp,
                      isDisabled: request.parentPhone.trim().isEmpty,
                      onPressed: () => _openWhatsApp(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RegistrationFilledButton(
                      title: s.approveAccountActivation,
                      color: ColorManager.orangeF9,
                      icon: Icons.check,
                      isLoading: isApproving,
                      onPressed: () => cubit.approveRegistration(
                        studentId: request.studentId,
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  StatusActionButton(
                    isLoading: isRejecting,
                    onPressed: () =>
                        cubit.rejectRegistration(studentId: request.studentId),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  bool _isAccountActionState(RegistrationRequestActionsState state) {
    return switch (state) {
      RegistrationRequestActionLoading(:final studentId, :final actionType) ||
      RegistrationRequestActionSuccess(:final studentId, :final actionType) ||
      RegistrationRequestActionFailure(:final studentId, :final actionType) =>
        studentId == request.studentId &&
            actionType != RegistrationRequestActionType.confirmPayment,
      _ => false,
    };
  }

  void _onAccountActionState(
    BuildContext context,
    RegistrationRequestActionsState state,
  ) {
    if (state is RegistrationRequestActionFailure) {
      showCustomSnackBar(context, state.errorMessage, false);
      return;
    }
    if (state is! RegistrationRequestActionSuccess) return;

    final message = state.actionType == RegistrationRequestActionType.approve
        ? S.of(context).accountActivatedSuccessfully
        : S.of(context).registrationRequestRejectedSuccessfully;
    showCustomSnackBar(context, message, true);
    context.read<GetRegistrationRequestsCubit>().getRegistrationRequests(
      refresh: true,
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final opened = await WhatsAppLauncher.open(request.parentPhone);
    if (!opened && context.mounted) {
      showCustomSnackBar(context, S.of(context).unableToOpenWhatsApp, false);
    }
  }

  Future<void> _showPaymentDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<RegistrationRequestActionsCubit>(),
        child: ConfirmRegistrationPaymentDialog(studentId: request.studentId),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    showCustomSnackBar(
      context,
      S.of(context).paymentConfirmedSuccessfully,
      true,
    );
    await context.read<GetRegistrationRequestsCubit>().getRegistrationRequests(
      refresh: true,
    );
  }
}
