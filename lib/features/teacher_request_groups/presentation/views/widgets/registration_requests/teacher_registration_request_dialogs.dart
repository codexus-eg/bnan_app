import 'package:bnan_app/core/helper/app_dialogs.dart';
import 'package:bnan_app/features/teacher_request_groups/presentation/views/dialogs/accept_registration_request_dialog.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationRequestDialogs {
  const TeacherRegistrationRequestDialogs._();

  static Future<void> showAcceptRequest(
    BuildContext context, {
    required String studentName,
    Future<void> Function()? onAccept,
  }) {
    return AppDialogs.show(
      context: context,
      barrierDismissible: false,
      child: AcceptRegistrationRequestDialog(
        studentName: studentName,
        onAccept: onAccept,
      ),
    );
  }
}
