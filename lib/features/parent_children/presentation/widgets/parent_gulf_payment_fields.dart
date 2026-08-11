import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_option_tile.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentGulfPaymentFields extends StatelessWidget {
  const ParentGulfPaymentFields({
    super.key,
    required this.onCityChanged,
    required this.onRegionChanged,
    required this.onLine1Changed,
    required this.onLine2Changed,
  });
  final ValueChanged<String> onCityChanged, onRegionChanged;
  final ValueChanged<String> onLine1Changed, onLine2Changed;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        PaymentOptionTile(
          title: s.tabbyTamara,
          icon: ImageManager.tamaraIcon,
          isSelected: true,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.city,
          isRequired: true,
          onChanged: onCityChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.parentRegion,
          isRequired: true,
          onChanged: onRegionChanged,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.parentAddressLine1,
          isRequired: true,
          onChanged: onLine1Changed,
        ),
        const SizedBox(height: 16),
        CustomTextField(label: s.parentAddressLine2, onChanged: onLine2Changed),
      ],
    );
  }
}
