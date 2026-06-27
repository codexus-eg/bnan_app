import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class DocumentPreviewButtonLabel extends StatelessWidget {
  const DocumentPreviewButtonLabel({
    super.key,
    required this.title,
    required this.isPrimary,
  });

  final String title;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final color = isPrimary ? ColorManager.white : ColorManager.mainColor14;
    return Text(
      title,
      style: StylesManager.styleBold12(context).copyWith(color: color),
    );
  }
}
