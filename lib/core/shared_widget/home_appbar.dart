import 'package:bnan_app/core/shared_widget/home_appbar_icon.dart';
import 'package:bnan_app/core/shared_widget/home_appbar_title.dart';
import 'package:bnan_app/core/shared_widget/notification_appbar_icon.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
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
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 14),
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
              HomeAppBarIcon(icon: ImageManager.listIcon, onTap: onMenuTap),
              const SizedBox(width: 12),
              Expanded(child: HomeAppBarTitle(userName: userName)),
              const SizedBox(width: 12),
              NotificationAppBarIcon(onTap: onNotificationTap),
            ],
          ),
        ),
      ),
    );
  }
}
