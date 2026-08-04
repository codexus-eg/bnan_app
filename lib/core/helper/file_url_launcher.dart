import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileUrlLauncher {
  const FileUrlLauncher._();

  static bool isValidWebUrl(String url) {
    final uri = Uri.tryParse(url.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static Future<bool> open(String url) async {
    final value = url.trim();
    if (value.isEmpty) return false;
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) return false;

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      debugPrint('FILE OPEN ERROR: $error');
      debugPrint('FILE URL: $value');

      return false;
    }
  }
}
