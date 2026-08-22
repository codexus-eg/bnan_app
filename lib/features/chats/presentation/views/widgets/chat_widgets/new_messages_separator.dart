import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class NewMessagesSeparator extends StatelessWidget {
  const NewMessagesSeparator({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(color: ColorManager.greyA8AF)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          S.of(context).newMessages,
          style: StylesManager.styleMedium14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
      ),
      const Expanded(child: Divider(color: ColorManager.greyA8AF)),
    ],
  );
}
