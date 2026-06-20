import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_chats/data/models/teacher_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TeacherChatCard extends StatelessWidget {
  const TeacherChatCard({super.key, required this.chatModel});

  final TeacherChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomDetailsWidgetBackground(
        child: Row(
          children: [
            CustomAvatar(firstName: chatModel.name, radius: 25),
            const SizedBox(width: 7),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  chatModel.name,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
                const SizedBox(height: 8),
                Text(
                  chatModel.grade,
                  style: StylesManager.styleRegular14(
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
