import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class AssignmentStatusBadge extends StatelessWidget {
  const AssignmentStatusBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 2),
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