import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/socket/socket_service.dart';
import 'package:flutter/material.dart';

abstract class AppLogout {
  static Future<void> perform(BuildContext context) async {
    try {
      await SessionManager.instance.clearSession();
      if (await SessionManager.instance.isLoggedIn()) {
        throw StateError('Authentication session was not cleared');
      }
      getIt<SocketService>().disconnect();
      if (!context.mounted) return;
      MyNavigator.goToOffAll(context, Routes.logIn);
    } catch (error) {
      if (!context.mounted) return;
      showCustomSnackBar(context, error.toString(), false);
    }
  }
}
