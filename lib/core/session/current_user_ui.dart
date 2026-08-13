import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';

abstract class CurrentUserUi {
  static String name(BuildContext context) {
    final user = SessionManager.instance.currentUser;
    return _present(user?.fullName) ??
        _present(user?.email) ??
        S.of(context).userName;
  }

  static String role(BuildContext context) {
    final s = S.of(context);
    return switch (SessionManager.instance.role) {
      UserRole.admin => s.admin,
      UserRole.supervisor => s.supervisor,
      UserRole.teacher => s.teacher,
      UserRole.student => s.student,
      UserRole.parent => s.parentGuardian,
      null => s.role,
    };
  }
}

String? _present(String? value) {
  final trimmed = value?.trim();
  return trimmed?.isNotEmpty == true ? trimmed : null;
}
