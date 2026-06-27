import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class IdealStudentTextColumn extends StatelessWidget {
  const IdealStudentTextColumn({
    super.key,
    required this.name,
    required this.nameColor,
    required this.bottom,
  });

  final String name;
  final Color nameColor;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: StylesManager.styleBold16(context).copyWith(color: nameColor),
        ),
        const SizedBox(height: 8),
        bottom,
      ],
    );
  }
}
