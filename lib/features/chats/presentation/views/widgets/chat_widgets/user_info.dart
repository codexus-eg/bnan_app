import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/view_class_schedule_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key, required this.chatTitle, this.onViewSchedule});

  final String chatTitle;
  final VoidCallback? onViewSchedule;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chatTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold20(
            context,
          ).copyWith(color: ColorManager.white),
        ),
        const SizedBox(height: 4),
        _status(context),
        if (onViewSchedule != null) ...[
          const SizedBox(height: 6),
          ViewClassScheduleButton(onTap: onViewSchedule!),
        ],
      ],
    );
  }

  Widget _status(BuildContext context) => Row(
    children: [
      const CircleAvatar(radius: 4, backgroundColor: Colors.green),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          S.of(context).onlineNow,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleRegular14(
            context,
          ).copyWith(color: ColorManager.greyE8E9),
        ),
      ),
    ],
  );
}
