import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   S.of(context).paymentMethod,
        //   style: StylesManager.styleBold16(
        //     context,
        //   ).copyWith(color: ColorManager.mainColor15),
        // ),
        // const SizedBox(height: 16),
        PaymentMethodCard(
          packageName: S.of(context).package4Hours,
          price: '160',
          studentsCount: '1',
          total: '160',
        ),
        const SizedBox(height: 16),
        const PaymentMethodsOptions(),
      ],
    );
  }
}
