import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomChatCard extends StatelessWidget {
  const CustomChatCard({super.key,required this.title, required this.subtitle, this.subtitleStyle});

  final String title,subtitle;
  final TextStyle? subtitleStyle;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomDetailsWidgetBackground(
        child: Row(
          children: [
            CustomAvatar(firstName: title, radius: 25),
            const SizedBox(width: 7),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style:subtitleStyle ?? StylesManager.styleRegular14(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ),
            Spacer(),
            SvgPicture.asset(ImageManager.chatIcon),
          ],
        ),
      ),
    );
  }
}
