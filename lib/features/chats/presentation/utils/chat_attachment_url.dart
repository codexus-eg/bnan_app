import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract final class ChatAttachmentUrl {
  static final Uri _backendOrigin = Uri.parse(EndPoints.socketUrl);

  static Uri? resolve(String? rawUrl) {
    final value = rawUrl?.trim();
    if (value == null || value.isEmpty || value.contains(RegExp(r'\s'))) {
      return null;
    }

    final parsed = Uri.tryParse(value);
    if (parsed == null) return null;
    if (parsed.hasScheme) {
      final resolved = _replaceLoopbackOrigin(parsed);
      return _isWebUri(resolved) ? resolved : null;
    }
    if (value.startsWith('//')) return null;

    final relativePath = value.startsWith('/') ? value : '/$value';
    final resolved = _backendOrigin.resolve(relativePath);
    return _isWebUri(resolved) ? resolved : null;
  }

  static Map<String, String> headersFor(Uri uri, {String? accessToken}) {
    if (uri.scheme != _backendOrigin.scheme ||
        uri.authority != _backendOrigin.authority) {
      return const {};
    }
    final token = accessToken ?? SessionManager.instance.accessToken;
    return token?.trim().isNotEmpty == true
        ? {'Authorization': 'Bearer ${token!.trim()}'}
        : const {};
  }

  static bool _isWebUri(Uri uri) {
    return (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  static Uri _replaceLoopbackOrigin(Uri uri) {
    if (!const {'127.0.0.1', 'localhost', '::1'}.contains(uri.host)) return uri;
    return Uri(
      scheme: _backendOrigin.scheme,
      host: _backendOrigin.host,
      port: _backendOrigin.hasPort ? _backendOrigin.port : null,
      path: uri.path,
      query: uri.hasQuery ? uri.query : null,
      fragment: uri.hasFragment ? uri.fragment : null,
    );
  }
}
