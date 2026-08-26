import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef ExternalSchemeOpener = Future<bool> Function(Uri uri);

abstract final class PaymobNavigationPolicy {
  static Future<NavigationDecision> decide(
    String url, {
    ExternalSchemeOpener? openExternal,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return NavigationDecision.prevent;
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return NavigationDecision.navigate;
    }
    try {
      await (openExternal ?? _openExternal)(uri);
    } catch (_) {
      // Keep checkout open when the target app is unavailable.
    }
    return NavigationDecision.prevent;
  }

  static Future<bool> _openExternal(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}
