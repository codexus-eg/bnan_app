import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/get_registration_requests_cubit/get_registration_requests_cubit.dart';
import 'package:bnan_app/features/registration_requests/presentation/manager/registration_request_actions_cubit/registration_request_actions_cubit.dart';
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
    final s = S.of(context);
    final isCompleted =
        request.registrationStatus == 'approved' ||
        request.registrationStatus == 'rejected';
    final isPaymentConfirmed = request.isPaymentConfirmed;

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
                child: RegistrationOutlinedButton(title: s.contactWhatsApp),
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
                ),
              ),
              const SizedBox(width: 22),
              StatusActionButton(onPressed: () {}),
            ],
          ),
        ],
      ],
    );
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
