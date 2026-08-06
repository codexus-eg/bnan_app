import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatMessageField extends StatelessWidget {
  const ChatMessageField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    this.enabled = true,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: ColorManager.blueD0DE.withAlpha((255 * .35).round()),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        textAlign: TextAlign.start,
        cursorColor: ColorManager.mainColor14,
        textInputAction: TextInputAction.send,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          // contentPadding: const EdgeInsetsDirectional.symmetric(
          //   horizontal: 8,
          //   vertical: 12,
          // ),
          hintText: S.of(context).typeMessage,
          border: InputBorder.none,
          hintStyle: StylesManager.styleRegular12(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
      ),
    );
  }
}
