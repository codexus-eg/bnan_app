import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/schedule/presentation/views/widgets/chat_widgets/chat_circle_button.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final double safeAreaBottom = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 8,
        top: 24,
        end: 9,
        bottom: keyboardHeight > 0
            ? (keyboardHeight - safeAreaBottom - 30).clamp(0.0, double.infinity)
            : MediaQuery.of(context).size.height * (27 / 812),
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          ChatCircleButton(icon: ImageManager.attachmentLineIcon, onTap: () {}),
          const SizedBox(width: 25),
          Expanded(child: _MessageField()),
          const SizedBox(width: 25),
          ChatCircleButton(
            icon: ImageManager.microphoneIcon,
            isDark: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),

          ChatCircleButton(
            icon: ImageManager.tablerSendIcon,
            isDark: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MessageField extends StatelessWidget {
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
        textAlign: TextAlign.start,
        
        cursorColor: ColorManager.mainColor14,
        decoration: InputDecoration(
          contentPadding: EdgeInsetsDirectional.symmetric(
            horizontal: 8,
            vertical: 12,
          ),
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
