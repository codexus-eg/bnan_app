import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(S.of(context).paymentMethod),
        const SizedBox(height: 14),
        PaymentMethodCard(
          title: S.of(context).package4Hours,
          subtitle: S.of(context).packagePrice('160'),
          icon: Icons.access_time,
        ),
        const SizedBox(height: 12),
        PaymentMethodCard(title: S.of(context).applePay, icon: Icons.apple),
        const SizedBox(height: 12),
        PaymentMethodCard(title: S.of(context).creditCard, icon: Icons.credit_card),
        const SizedBox(height: 12),
        PaymentMethodCard(title: S.of(context).tabbyTamara, icon: Icons.payments),
      ],
    );
  }
}