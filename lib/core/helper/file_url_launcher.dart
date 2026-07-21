import 'package:url_launcher/url_launcher.dart';

class FileUrlLauncher {
  const FileUrlLauncher._();

  static Future<bool> open(String url) async {
    final value = url.trim();

    if (value.isEmpty) return false;

    final uri = Uri.tryParse(value);

    if (uri == null || !uri.hasScheme) {
      return false;
    }

    if (!await canLaunchUrl(uri)) {
      return false;
    }

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}