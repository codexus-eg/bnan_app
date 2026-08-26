import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentMethodsOptions extends StatelessWidget {
  const PaymentMethodsOptions({
    super.key,
    required this.selectedProvider,
    required this.onChanged,
  });

  final GulfPaymentProvider selectedProvider;
  final ValueChanged<GulfPaymentProvider> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      PaymentOptionTile(
        title: S.of(context).tabbyTamara,
        icon: ImageManager.tamaraIcon,
        isSelected: selectedProvider == GulfPaymentProvider.tamara,
        onTap: () => onChanged(GulfPaymentProvider.tamara),
      ),
      const SizedBox(height: 8),
      PaymentOptionTile(
        title: S.of(context).paymob,
        icon: ImageManager.financeIcon,
        isSelected: selectedProvider == GulfPaymentProvider.paymob,
        onTap: () => onChanged(GulfPaymentProvider.paymob),
      ),
    ],
  );
}
