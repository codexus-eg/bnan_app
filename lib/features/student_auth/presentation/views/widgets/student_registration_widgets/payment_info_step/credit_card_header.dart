import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditCardHeader extends StatelessWidget {
  const CreditCardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SvgPicture.asset(
              ImageManager.bankIcon,
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                ColorManager.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'FYI BANK',
              style: StylesManager.styleBold16(context).copyWith(
                color: ColorManager.white,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            'CREDIT',
            style: StylesManager.styleBold16(context).copyWith(
              color: ColorManager.white,
            ),
          ),
        ),
      ],
    );
  }
}
