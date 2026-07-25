import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_form_controllers.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_prices_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageFormContent extends StatelessWidget {
  const PackageFormContent({
    super.key,
    required this.controllers,
    required this.currency,
    required this.onCurrencyChanged,
  });

  final PackageFormControllers controllers;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          label: S.of(context).packageFormName,
          hintText: S.of(context).packageDurationHint,
          controller: controllers.name,
          isRequired: true,
        ),
        const SizedBox(height: 14),
        CustomTextField(
          label: S.of(context).packageDuration,
          hintText: S.of(context).packageDurationHint,
          controller: controllers.duration,
          keyboardType:TextInputType.number ,
          isRequired: true,
        ),
        const SizedBox(height: 14),
        PackagePricesRow(
          oldPrice: controllers.oldPrice,
          newPrice: controllers.newPrice,
          currency: currency,
          onCurrencyChanged: onCurrencyChanged,
        ),
        const SizedBox(height: 14),
        // CustomTextField(
        //   label: S.of(context).discountTitle,
        //   hintText: S.of(context).discountTitleHint,
        //   controller: controllers.discountTitle,
        // ),
      ],
    );
  }
}
