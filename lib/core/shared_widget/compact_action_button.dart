import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CompactActionButton extends StatelessWidget {
  const CompactActionButton({super.key, required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: ColorManager.greyA8AF,
          foregroundColor: ColorManager.mainColor14,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          title,
          style: StylesManager.styleBold12(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
      ),
    );
  }
}
