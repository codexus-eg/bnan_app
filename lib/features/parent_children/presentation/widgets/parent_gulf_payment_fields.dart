import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentGulfPaymentFields extends StatelessWidget {
  const ParentGulfPaymentFields({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return PaymentOptionTile(
      title: s.tabbyTamara,
      icon: ImageManager.tamaraIcon,
      isSelected: true,
      onTap: () {},
    );
  }
}
