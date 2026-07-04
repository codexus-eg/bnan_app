import 'package:bnan_app/core/shared_widget/custom_chip.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsRowSection extends StatelessWidget {
  const DetailsRowSection({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final String iconPath, title, subtitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      padding: const EdgeInsetsDirectional.all(4),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            height: 16,
            width: 16,
            colorFilter: ColorFilter.mode(
              ColorManager.mainColor14,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleMedium14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
          ),
          const SizedBox(width: 5),
          Customship(subtitle),
          const SizedBox(width: 26),
          InkWell(
            onTap: onTap,
            child: SvgPicture.asset(ImageManager.trash, height: 24, width: 4),
          ),
        ],
      ),
    );
  }
}
