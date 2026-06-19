
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherStatusBadge extends StatelessWidget {
  const TeacherStatusBadge({super.key, 
    required this.title,
    required this.color,
    required this.textColor,
  });

  final String title;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        title,
        style: StylesManager.styleBold12(context).copyWith(
          color: textColor
        )
      ),
    );
  }
}
