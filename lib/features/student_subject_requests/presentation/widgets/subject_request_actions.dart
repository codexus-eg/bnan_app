import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubjectRequestActions extends StatelessWidget {
  const SubjectRequestActions({super.key, this.onClassroom, this.onChat});

  final VoidCallback? onClassroom;
  final VoidCallback? onChat;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (onClassroom != null)
        Expanded(
          child: CustomAppButton(
            height: 38,
            text: S.of(context).classRoom,
            onPressed: onClassroom,
          ),
        ),
      if (onClassroom != null && onChat != null) const SizedBox(width: 8),
      if (onChat != null)
        Expanded(
          child: CustomAppButton(
            height: 38,
            text: S.of(context).messages,
            backgroundColor: ColorManager.white,
            textColor: ColorManager.mainColor14,
            borderColor: ColorManager.mainColor14,
            onPressed: onChat,
          ),
        ),
    ],
  );
}
