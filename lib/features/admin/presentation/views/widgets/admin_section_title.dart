import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AdminSectionTitle extends StatelessWidget {
  const AdminSectionTitle({
    super.key,
    required this.title,
    this.showTrendIcon = false,
  });

  final String title;
  final bool showTrendIcon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTrendIcon)
            SvgPicture.asset(
              ImageManager.arrowGrowthIcon,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                ColorManager.green33B,
                BlendMode.srcIn,
              ),
            ),
          if (showTrendIcon) const SizedBox(width: 4),
          Text(
            title,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ],
      ),
    );
  }
}
