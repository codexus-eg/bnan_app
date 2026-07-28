import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/payment_status_chip.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/confirm_registration_payment_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentReviewBox extends StatelessWidget {
  const PaymentReviewBox({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isConfirmed = request.paymentStatus == 'confirmed';
    final hasPayment =
        request.paymentAmount != null ||
        request.paymentStatus == 'pending' ||
        request.paymentStatus == 'confirmed' ||
        request.paymentStatus == 'rejected';
    final paymentStatusText = !hasPayment
        ? s.newCustomer
        : request.paymentStatus == 'rejected'
        ? s.reject
        : s.paymentCompleted;

    return Container(
      padding: const EdgeInsetsDirectional.only(
        start: 4,
        top: 4,
        end: 4,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.paymentStatus,
                    style: StylesManager.styleBold10(
                      context,
                    ).copyWith(color: ColorManager.mainColor14),
                  ),
                  if (request.paymentAmount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${s.amount} ${request.paymentAmount}',
                      style: StylesManager.styleRegular10(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                  ],
                ],
              ),
              const Spacer(),
              PaymentStatusChip(text: paymentStatusText),
            ],
          ),
          const SizedBox(height: 8),
          RegistrationFilledButton(
            title: isConfirmed
                ? s.paymentCompleted
                : s.manualPaymentConfirmation,
            color: ColorManager.secondaryColor,
            onPressed: isConfirmed
                ? null
                : () => showDialog<void>(
                    context: context,
                    builder: (_) => const ConfirmRegistrationPaymentDialog(),
                  ),
          ),
        ],
      ),
    );
  }
}
