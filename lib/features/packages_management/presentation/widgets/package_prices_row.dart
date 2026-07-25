import 'package:bnan_app/features/packages_management/presentation/widgets/package_currency_field.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_price_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackagePricesRow extends StatelessWidget {
  const PackagePricesRow({
    super.key,
    required this.oldPrice,
    required this.newPrice,
    required this.currency,
    required this.onCurrencyChanged,
  });

  final TextEditingController oldPrice;
  final TextEditingController newPrice;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: PackagePriceField(
            title: S.of(context).packageOldPrice,
            controller: oldPrice,
            hintText: '200',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: PackagePriceField(
            title: S.of(context).newPrice,
            controller: newPrice,
            hintText: '120',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: PackageCurrencyField(
            title: S.of(context).currency,
            value: currency,
            onChanged: onCurrencyChanged,
          ),
        ),
      ],
    );
  }
}