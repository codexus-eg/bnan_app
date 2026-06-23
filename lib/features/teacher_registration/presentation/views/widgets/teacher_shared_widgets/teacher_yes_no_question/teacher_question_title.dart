import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class TeacherQuestionTitle extends StatelessWidget {
  const TeacherQuestionTitle({
    super.key,
    required this.question,
    required this.isRequired,
    this.style,
    this.mainAxisAlignment,
  });

  final String question;
  final bool isRequired;
  final TextStyle? style;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            question,
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                style ??
                StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
          ),
        ),
        if (isRequired) const Text('*', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
