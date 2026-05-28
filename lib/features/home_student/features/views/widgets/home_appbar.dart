import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.userName,
    required this.onMenuTap,
    required this.onNotificationTap,
  });

  final String userName;
  final VoidCallback onMenuTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        start: 20,
        end: 20,
        bottom: 14,
      ),
      decoration: const BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeAppBarIcon(
                icon: ImageManager.listIcon,
                onTap: onMenuTap,
              ),
              const Spacer(),
              _HomeAppBarTitle(userName: userName),
              const Spacer(),
              HomeAppBarIcon(
                icon: ImageManager.bellIcon,
                onTap: onNotificationTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBarTitle extends StatelessWidget {
  const _HomeAppBarTitle({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).welcomeYou,
          style: StylesManager.styleBold14(context).copyWith(
            color: ColorManager.greyA8AF,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          userName,
          style: StylesManager.styleBold20(context).copyWith(
            color: ColorManager.white,
          ),
        ),
      ],
    );
  }
}

class HomeAppBarIcon extends StatelessWidget {
  const HomeAppBarIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
  });

  final String icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SvgPicture.asset(
        icon,
        width: size,
        height: size,
        colorFilter: const ColorFilter.mode(
          ColorManager.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}