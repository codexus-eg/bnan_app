import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.padding = 0, this.backgroundColor, this.textColor,
  });

  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? padding;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: padding ?? 0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:backgroundColor?? ColorManager.mainColor14,
          disabledBackgroundColor: ColorManager.greyA8AF,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text, style: StylesManager.styleBold16(context).copyWith(
              color: textColor
            )),
      ),
    );
  }
}
