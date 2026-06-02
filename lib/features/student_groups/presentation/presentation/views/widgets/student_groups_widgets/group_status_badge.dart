import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class GroupStatusBadge extends StatelessWidget {
  const GroupStatusBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 49
      ),
      padding: const EdgeInsetsDirectional.symmetric(vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.mainColor14,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: StylesManager.styleBold12(context).copyWith(
          color: ColorManager.white,
        ),
      ),
    );
  }
}