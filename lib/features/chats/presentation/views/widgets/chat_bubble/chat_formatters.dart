import 'package:flutter/widgets.dart';

class ChatFormatters {
  const ChatFormatters._();

  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String formatTime(DateTime? dateTime, {BuildContext? context}) {
    if (dateTime == null) {
      return '00:00';
    }

    final local = dateTime.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final arabic =
        context != null && Localizations.localeOf(context).languageCode == 'ar';
    final period = local.hour < 12
        ? (arabic ? 'ص' : 'AM')
        : (arabic ? 'م' : 'PM');
    return '$hour:$minute $period';
  }

  static String senderLabel(BuildContext context, String name, String role) {
    final roleLabel = _roleLabel(context, role);
    return roleLabel.isEmpty ? name.trim() : '${name.trim()} ($roleLabel)';
  }

  static String _roleLabel(BuildContext context, String role) {
    final arabic = Localizations.localeOf(context).languageCode == 'ar';
    return switch (role.trim().toLowerCase()) {
      'student' => arabic ? 'طالب' : 'Student',
      'teacher' => arabic ? 'معلم' : 'Teacher',
      'parent' => arabic ? 'ولي أمر' : 'Parent',
      'admin' => arabic ? 'إدارة' : 'Administration',
      'supervisor' => arabic ? 'مشرف' : 'Supervisor',
      _ => '',
    };
  }
}
