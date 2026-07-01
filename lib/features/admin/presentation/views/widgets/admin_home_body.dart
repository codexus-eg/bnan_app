import 'package:bnan_app/features/admin/presentation/views/widgets/admin_home_layout.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_placeholder_tab.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/users_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminHomeBody extends StatelessWidget {
  const AdminHomeBody({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final pages = [
      AdminHomeLayout(onMenuTap: onMenuTap),
      UsersManagementBody(),
      AdminPlaceholderTab(title: s.adminSupervisors, onMenuTap: onMenuTap),
      AdminPlaceholderTab(title: s.subjects, onMenuTap: onMenuTap),
      AdminPlaceholderTab(title: s.packages, onMenuTap: onMenuTap),
    ];

    return pages[index];
  }
}
