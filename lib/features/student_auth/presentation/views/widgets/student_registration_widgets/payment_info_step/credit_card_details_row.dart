import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CreditCardDetailsRow extends StatelessWidget {
  const CreditCardDetailsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'VALID\nTHRU',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 5,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '5/23',
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.white,
          ),
        ),
        const SizedBox(width: 70),
        Text(
          '633',
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.white,
          ),
        ),
      ],
    );
  }
}
