import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomAppButton extends StatelessWidget {
  const CustomAppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.padding = 0,
    this.backgroundColor,
    this.textColor,
    this.style,
    this.borderColor,
    this.height,
    this.singleLine = false,
  });

  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final bool singleLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: double.infinity,
      padding: EdgeInsetsDirectional.symmetric(horizontal: padding ?? 0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? ColorManager.mainColor14,
          disabledBackgroundColor: ColorManager.grey7A7C,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: borderColor ?? Colors.transparent),
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
            : Text(
                text,
                maxLines: singleLine ? 1 : null,
                softWrap: !singleLine,
                overflow: singleLine ? TextOverflow.ellipsis : null,
                style:
                    style ??
                    StylesManager.styleButton(
                      context,
                      color: textColor,
                    ),
              ),
      ),
    );
  }
}
