import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class WeeklyPlanHeaderCell extends StatelessWidget {
  const WeeklyPlanHeaderCell({
    super.key,
    required this.text,
    required this.width,
    required this.backgroundColor,
    required this.textColor,
  });

  final String text;
  final double width;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        height: 32,
        margin: const EdgeInsetsDirectional.all(2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: StylesManager.styleBold10(context).copyWith(color: textColor),
        ),
      ),
    );
  }
}
