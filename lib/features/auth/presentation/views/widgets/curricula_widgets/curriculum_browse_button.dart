import 'package:bnan_app/core/shared_widget/custom_back_icon.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CurriculumBrowseButton extends StatelessWidget {
  const CurriculumBrowseButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ColorManager.mainColor14,
          padding: const EdgeInsetsDirectional.only(start: 15, end: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: ColorManager.white),
            ),
            const SizedBox(width: 15),
            CustomBackIcon(size: 20, color: ColorManager.white),
          ],
        ),
      ),
    );
  }
}
