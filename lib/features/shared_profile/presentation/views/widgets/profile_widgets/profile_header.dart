import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageManager.userProfileIcon,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                ColorManager.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              S.of(context).personalProfile,
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsetsDirectional.only(
            top: 4,
            end: 7.5,
            start: 7.5,
            bottom: 3,
          ),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ImageManager.starOutlinedIcon,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                colorFilter: const ColorFilter.mode(
                  ColorManager.mainColor14,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                role,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
