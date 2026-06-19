import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomDialogHeader extends StatelessWidget {
  const CustomDialogHeader({super.key, required this.title, this.style});

  final String title;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style:style?? StylesManager.styleBold16(
            context,
          ).copyWith(color: ColorManager.black),
        ),
        const Spacer(),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, size: 22),
        ),
      ],
    );
  }
}
