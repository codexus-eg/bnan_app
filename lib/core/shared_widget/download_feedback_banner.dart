import 'dart:async';

import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

void showDownloadFeedbackBanner(
  BuildContext context, {
  required String message,
  required bool success,
  String? location,
  String? openLabel,
  VoidCallback? onOpen,
}) {
  final messenger = ScaffoldMessenger.of(context)..hideCurrentMaterialBanner();
  final controller = messenger.showMaterialBanner(
    MaterialBanner(
      backgroundColor: ColorManager.greyF8F9,
      leading: Icon(
        success ? Icons.check_circle : Icons.error,
        color: success ? ColorManager.green23 : ColorManager.redD8,
      ),
      content: Text(
        location == null ? message : '$message\n$location',
        style: StylesManager.styleRegular14(context),
      ),
      actions: [
        if (onOpen != null)
          TextButton(onPressed: onOpen, child: Text(openLabel ?? '')),
        IconButton(
          onPressed: () => messenger.hideCurrentMaterialBanner(),
          icon: const Icon(Icons.close),
        ),
      ],
    ),
  );
  unawaited(Future<void>.delayed(const Duration(seconds: 4), controller.close));
}
