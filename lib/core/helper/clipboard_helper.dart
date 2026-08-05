import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClipboardHelper {
  const ClipboardHelper._();

  static Future<void> copy(BuildContext context, String? value) async {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return;

    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (context.mounted) {
        showCustomSnackBar(context, S.of(context).copiedSuccessfully, true);
      }
    } catch (_) {
      if (context.mounted) {
        showCustomSnackBar(context, S.of(context).failedToCopy, false);
      }
    }
  }
}
