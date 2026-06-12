import 'package:url_launcher/url_launcher.dart';

class FileUrlLauncher {
  static Future<bool> download(String url) async {
    if (url.trim().isEmpty) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    return launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }
}