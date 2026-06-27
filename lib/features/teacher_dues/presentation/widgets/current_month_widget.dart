import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrentMonthWidget extends StatelessWidget {
  const CurrentMonthWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          S.of(context).currentMonth,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: Colors.white),
        ),
        const Spacer(),
        SvgPicture.asset(
          ImageManager.wallet,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(
            ColorManager.white,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}


