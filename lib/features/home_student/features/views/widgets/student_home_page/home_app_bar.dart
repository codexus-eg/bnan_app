import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/home_student/features/views/widgets/home_appbar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

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
        start: 23,
        end: 16,
        top: 16,
        bottom: 11,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeAppBarIcon(
              icon: ImageManager.listIcon,
              onTap: onMenuTap,
              size: 24,
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).welcomeYou,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: StylesManager.styleBold20(
                    context,
                  ).copyWith(color: ColorManager.white),
                ),
              ],
            ),
            const Spacer(),
            HomeAppBarIcon(
              icon: ImageManager.bellIcon,
              onTap: onNotificationTap,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
