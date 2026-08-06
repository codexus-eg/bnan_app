import 'package:bnan_app/core/helper/file_url_launcher.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<void> openDocumentLink(BuildContext context, String? link) async {
  final value = link?.trim();
  if (value == null || value.isEmpty || !FileUrlLauncher.isValidWebUrl(value)) {
    showCustomSnackBar(context, S.of(context).unableToOpenLink, false);
    return;
  }
  final opened = await FileUrlLauncher.open(value);
  if (!context.mounted || opened) return;
  showCustomSnackBar(context, S.of(context).unableToOpenLink, false);
}
