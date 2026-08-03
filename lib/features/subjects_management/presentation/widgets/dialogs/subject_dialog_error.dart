import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class SubjectDialogError extends StatelessWidget {
  const SubjectDialogError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        message,
        textAlign: TextAlign.start,
        style: StylesManager.styleRegular14(
          context,
        ).copyWith(color: ColorManager.red),
      ),
    );
  }
}
