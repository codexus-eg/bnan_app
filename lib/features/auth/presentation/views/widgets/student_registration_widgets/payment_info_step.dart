import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/credit_card_preview.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentInfoStep extends StatelessWidget {
  const PaymentInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(S.of(context).paymentInfo),
        const SizedBox(height: 14),
        const CreditCardPreview(),
        const SizedBox(height: 16),
        CustomAuthTextField(label: S.of(context).cardNumber, hintText: ''),
        const SizedBox(height: 12),
        CustomAuthTextField(label: S.of(context).cardHolderName, hintText: ''),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: CustomAuthTextField(label: S.of(context).cvv, hintText: '---')),
            const SizedBox(width: 10),
            Expanded(child: CustomAuthTextField(label: S.of(context).expiryDate, hintText: 'mm/yy')),
          ],
        ),
      ],
    );
  }
}