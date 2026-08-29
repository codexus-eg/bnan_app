import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/helper/currency_formatter.dart';
import 'package:bnan_app/core/helper/package_display_formatter.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/itemized_payment_price.dart';
import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.packageName,
    required this.price,
    required this.studentsCount,
    required this.total,
    this.currency,
    this.quantityLabel,
    this.quantityFirst = false,
  });

  final String packageName;
  final String price;
  final String studentsCount;
  final String total;
  final String? currency;
  final String? quantityLabel;
  final bool quantityFirst;

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
            PackageDisplayFormatter.name(context, packageName),
            style: StylesManager.styleBold16(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
          const SizedBox(height: 4),
          quantityFirst
              ? ItemizedPaymentPrice(
                  count: studentsCount,
                  label: quantityLabel ?? S.of(context).subjects,
                  price: price,
                  total: total,
                  currency: symbol,
                )
              : Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '$price $symbol * '
                            '$studentsCount '
                            '${quantityLabel ?? S.of(context).student} = ',
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
