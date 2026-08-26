import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:flutter/material.dart';

class ParentGulfPaymentFields extends StatelessWidget {
  const ParentGulfPaymentFields({
    super.key,
    required this.selectedProvider,
    required this.onChanged,
  });

  final GulfPaymentProvider selectedProvider;
  final ValueChanged<GulfPaymentProvider> onChanged;

  @override
  Widget build(BuildContext context) => PaymentMethodsOptions(
    selectedProvider: selectedProvider,
    onChanged: onChanged,
  );
}
