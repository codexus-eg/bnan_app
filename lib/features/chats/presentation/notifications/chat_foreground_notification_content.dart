import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ChatForegroundNotificationContent extends StatelessWidget {
  const ChatForegroundNotificationContent({
    super.key,
    required this.sender,
    required this.preview,
  });

  final String sender;
  final String preview;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.chat_bubble_outline, color: ColorManager.mainColor14),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: StylesManager.styleMedium14(context),
            ),
            if (preview.isNotEmpty)
              Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.grey7A7C),
              ),
          ],
        ),
      ),
    ],
  );
}
