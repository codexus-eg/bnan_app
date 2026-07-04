import 'package:bnan_app/core/shared_widget/status_action_button.dart';
import 'package:bnan_app/features/registration_requests/data/models/registration_request_model.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/payment_review_box.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_filled_button.dart';
import 'package:bnan_app/features/registration_requests/presentation/view/widgets/registration_outlined_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class RegistrationRequestActionsSection extends StatelessWidget {
  const RegistrationRequestActionsSection({super.key, required this.request});

  final RegistrationRequestModel request;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        PaymentReviewBox(request: request),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RegistrationFilledButton(
                title: s.moveToReview,
                color: ColorManager.secondaryColor,
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
    );
  }
}
