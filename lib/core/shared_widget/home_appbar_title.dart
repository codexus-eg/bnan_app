import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class HomeAppBarTitle extends StatelessWidget {
  const HomeAppBarTitle({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          S.of(context).welcomeYou,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.greyA8AF),
        ),
        const SizedBox(height: 2),
        Text(
          userName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold20(
            context,
          ).copyWith(color: ColorManager.white),
        ),
      ],
    );
  }
}
