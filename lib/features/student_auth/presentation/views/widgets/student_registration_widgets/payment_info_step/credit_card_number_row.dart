import 'dart:math' as math;

import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CreditCardNumberRow extends StatelessWidget {
  const CreditCardNumberRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '0000  2363  8364  8269',
          style: StylesManager.styleBold16(context).copyWith(
            color: ColorManager.white,
            letterSpacing: .8,
          ),
        ),
        const Spacer(),
        Transform.rotate(
          angle: math.pi / 2,
          child: const Icon(
            Icons.wifi,
            color: ColorManager.white,
            size: 28,
          ),
        ),
      ],
    );
  }
}