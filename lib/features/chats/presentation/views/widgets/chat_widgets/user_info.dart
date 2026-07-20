import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).teacherSarahName,
          style: StylesManager.styleBold20(
            context,
          ).copyWith(color: ColorManager.white),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const CircleAvatar(radius: 4, backgroundColor: Colors.green),
            const SizedBox(width: 4),
            Text(
              S.of(context).onlineNow,
              style: StylesManager.styleRegular14(
                context,
              ).copyWith(color: ColorManager.greyE8E9),
            ),
          ],
        ),
      ],
    );
  }
}