import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PlansDialogErrorMessage extends StatelessWidget {
  const PlansDialogErrorMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.redFFF,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: StylesManager.styleRegular14(
          context,
        ).copyWith(color: ColorManager.red),
      ),
    );
  }
}
