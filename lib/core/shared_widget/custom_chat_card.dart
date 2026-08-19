import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomChatCard extends StatelessWidget {
  const CustomChatCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.subtitleStyle,
    this.badgeText,
    this.unreadCount = 0,
  });

  final String title;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final String? badgeText;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Row(
        children: [
          CustomAvatar(
            firstName: title,
            radius: 25,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StylesManager.styleBold16(
                          context,
                        ).copyWith(
                          color: ColorManager.mainColor14,
                        ),
                      ),
                    ),
                    if (badgeText != null) ...[
                      const SizedBox(width: 8),
                      StatusBadge(
                        text: badgeText!,
                        horizontalPadding: 8,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: subtitleStyle ??
                      StylesManager.styleRegular14(
                        context,
                      ).copyWith(
                        color: ColorManager.greyA8AF,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ImageManager.chatIcon,
              ),
              if (unreadCount > 0) ...[
                const SizedBox(height: 6),
                Container(
                  constraints: const BoxConstraints(
                    minWidth: 22,
                    minHeight: 22,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: ColorManager.mainColor14,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    unreadCount > 99
                        ? '99+'
                        : unreadCount.toString(),
                    style: const TextStyle(
                      color: ColorManager.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}