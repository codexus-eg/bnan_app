import 'package:bnan_app/core/network/end_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef ExternalSchemeOpener = Future<bool> Function(Uri uri);

abstract final class PaymobNavigationPolicy {
  static bool isSuccessReturnUrl(String url) {
    final actual = Uri.tryParse(url);
    final expected = Uri.parse('${EndPoints.baseUrl}/payment/paymob/success');
    if (actual == null || !actual.hasAuthority) return false;
    if (actual.host.toLowerCase() != expected.host.toLowerCase()) return false;

    final path = _normalizedPath(actual);
    final expectedPath = _normalizedPath(expected);
    return path == expectedPath ||
        path == '/payment/paymob/success' ||
        path == '/api/v1/payment/paymob/success' ||
        path == '/payment/paymob/callback' ||
        path == '/api/v1/payment/paymob/callback' ||
        path == '/payment/callback' ||
        path == '/api/v1/payment/callback';
  }

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

  static String _normalizedPath(Uri uri) {
    final path = uri.path;
    return path.length > 1 && path.endsWith('/')
        ? path.substring(0, path.length - 1)
        : path;
  }
}
