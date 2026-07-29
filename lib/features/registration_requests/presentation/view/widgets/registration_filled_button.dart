import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationFilledButton extends StatelessWidget {
  const RegistrationFilledButton({
    super.key,
    required this.title,
    required this.color,
    this.icon,
    this.onPressed,
    this.isDisabled = false,
    this.isLoading = false,
  });

  final String title;
  final Color color;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: ElevatedButton.icon(
        onPressed: isDisabled || isLoading ? null : (onPressed ?? () {}),
        icon: isLoading
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : icon == null
            ? const SizedBox.shrink()
            : Icon(icon, size: 18, color: Colors.white),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color,
          foregroundColor: Colors.white,
          textStyle: StylesManager.styleRegular10(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
