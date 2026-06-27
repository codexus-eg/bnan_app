import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopWinnerMedal extends StatelessWidget {
  const TopWinnerMedal({super.key, required this.isCurrentUser});

  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        CustomAvatar(
          firstName: 'مممممأ',
          backgroundColor: ColorManager.beigeEDC,
        ),
        Positioned(
          top: -8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 1),
              child: SvgPicture.asset(
                ImageManager.crownSimple,
                height: 18,
                width: 18,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  ColorManager.mainColor14,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
