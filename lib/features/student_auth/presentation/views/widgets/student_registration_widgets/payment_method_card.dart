import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/helper/currency_formatter.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.packageName,
    required this.price,
    required this.studentsCount,
    required this.total,
    this.currency,
  });

  final String packageName;
  final String price;
  final String studentsCount;
  final String total;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final symbol = CurrencyFormatter.symbol(context, currency);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: Border.all(color: ColorManager.mainColor14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).selectedPackage,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
          const SizedBox(height: 4),
          Text(
            packageName,
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '$price $symbol * '
                      '$studentsCount ${S.of(context).student} = ',
                  style: StylesManager.styleRegular14(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
                TextSpan(
                  text: '$total $symbol',
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor15),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
