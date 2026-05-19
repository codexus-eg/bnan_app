import 'package:flutter/material.dart';

const Color kSnackBg = Color(0xFFF3F5F4);     // خلفية فاتحة زي الصورة
const Color kTextColor = Color(0xFF2D2D2D);   // لون النص
const Color kCloseColor = Color(0xFF9E9E9E);  // لون X
const Color kSuccessColor = Color(0xFF2E7D32);
const Color kFailureColor = Color(0xFF8B3A48);

void showCustomSnackBar(
  BuildContext context,
  String message,
  bool isSuccess, {
  String? actionLabel,            // مثال: "UNDO"
  VoidCallback? onActionPressed,  // فعل الـ UNDO
}) {
  final Color iconColor = isSuccess ? kSuccessColor : kFailureColor;
  final IconData iconData = isSuccess ? Icons.check_circle : Icons.cancel;

  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      // نفس شكل الصورة: محتوى يسار + أكشن يمين + X
      content: Row(
        children: [
          Icon(iconData, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: kTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      backgroundColor: kSnackBg,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: const Duration(seconds: 3),

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      // زر X زي الصورة
      showCloseIcon: true,
      closeIconColor: kCloseColor,

      // "UNDO" يمين زي الصورة (هيظهر فقط لو onActionPressed مش null)
      action: onActionPressed == null
          ? null
          : SnackBarAction(
              label: (actionLabel ?? 'UNDO').toUpperCase(),
              onPressed: onActionPressed,
              textColor: iconColor,
            ),
    ),
  );
}
