import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$label\n',
        style: StylesManager.styleBold10(
          context,
        ).copyWith(color: ColorManager.mainColor14),
        children: [
          TextSpan(
            text: value,
            style: StylesManager.styleMedium10(
              context,
            )
          ),
        ],
      ),
      textAlign: TextAlign.start,
    );
  }
}
