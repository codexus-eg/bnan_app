import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentMethodsOptions extends StatelessWidget {
  const PaymentMethodsOptions({super.key});

  @override
  Widget build(BuildContext context) => PaymentOptionTile(
    title: S.of(context).tabbyTamara,
    icon: ImageManager.tamaraIcon,
    isSelected: true,
    onTap: () {},
  );
}
