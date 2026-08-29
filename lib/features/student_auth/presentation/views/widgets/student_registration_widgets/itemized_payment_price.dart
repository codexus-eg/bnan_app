import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ItemizedPaymentPrice extends StatelessWidget {
  const ItemizedPaymentPrice({
    super.key,
    required this.count,
    required this.label,
    required this.price,
    required this.total,
    required this.currency,
  });

  final String count, label, price, total, currency;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 5,
    runSpacing: 4,
    crossAxisAlignment: WrapCrossAlignment.center,
    textDirection: Directionality.of(context),
    children: [
      Text('$count $label', style: StylesManager.styleRegular14(context)),
      Text('×', style: StylesManager.styleRegular14(context)),
      _ltr('$price $currency', StylesManager.styleRegular14(context)),
      Text('=', style: StylesManager.styleRegular14(context)),
      _ltr(
        '$total $currency',
        StylesManager.styleBold16(
          context,
        ).copyWith(color: ColorManager.mainColor15),
      ),
    ],
  );

  Widget _ltr(String value, TextStyle style) =>
      Text(value, style: style, textDirection: TextDirection.ltr, maxLines: 1);
}
