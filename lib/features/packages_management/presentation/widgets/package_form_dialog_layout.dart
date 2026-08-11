import 'dart:math' as math;

import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:flutter/material.dart';

class PackageFormDialogLayout extends StatelessWidget {
  const PackageFormDialogLayout({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final unavailableHeight =
        MediaQuery.viewInsetsOf(context).bottom +
        MediaQuery.paddingOf(context).vertical +
        32;
    final availableHeight = math.max(0.0, size.height - unavailableHeight);
    final maxHeight = math.min(size.height * .86, availableHeight);

    return CustomAppDialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(title: title),
              const SizedBox(height: 18),
              Flexible(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
