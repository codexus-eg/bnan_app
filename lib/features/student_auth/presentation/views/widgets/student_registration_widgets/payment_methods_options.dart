import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';

class PaymentMethodsOptions extends StatefulWidget {
  const PaymentMethodsOptions({super.key});

  @override
  State<PaymentMethodsOptions> createState() => _PaymentMethodsOptionsState();
}

class _PaymentMethodsOptionsState extends State<PaymentMethodsOptions> {
  String selectedMethod = 'apple_pay';

  void _select(BuildContext context, String method) {
    if (RegisterCubit.get(context).isGulf && method != 'tamara') {
      showCustomSnackBar(context, 'غير متاح حاليًا', false);
      return;
    }
    setState(() => selectedMethod = method);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PaymentOptionTile(
                title: S.of(context).creditCard,
                icon: ImageManager.financeIcon,
                isSelected:
                    !RegisterCubit.get(context).isGulf &&
                    selectedMethod == 'credit_card',
                onTap: () => _select(context, 'credit_card'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PaymentOptionTile(
                title: S.of(context).applePay,
                icon: ImageManager.applePayIcon,
                isSelected:
                    !RegisterCubit.get(context).isGulf &&
                    selectedMethod == 'apple_pay',
                onTap: () => _select(context, 'apple_pay'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PaymentOptionTile(
          title: S.of(context).tabbyTamara,
          icon: ImageManager.tamaraIcon,
          isSelected:
              RegisterCubit.get(context).isGulf || selectedMethod == 'tamara',
          onTap: () => _select(context, 'tamara'),
        ),
      ],
    );
  }
}
