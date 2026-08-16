import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/session/session_manager.dart';

abstract final class AttachmentUrlResolver {
  static String resolve(String value) {
    final source = value.trim();
    if (source.isEmpty || source.startsWith('assets/')) return source;
    final base = Uri.parse(EndPoints.baseUrl);
    final uri = Uri.tryParse(source);
    if (uri == null) return '';
    if (uri.hasScheme) return _replaceLocalHost(uri, base);
    final origin = Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
    );
    if (source.startsWith('/')) return origin.resolve(source).toString();
    return Uri.parse('${EndPoints.baseUrl}/').resolve(source).toString();
  }

  static bool isPdf(String value) =>
      Uri.tryParse(value)?.path.toLowerCase().endsWith('.pdf') ?? false;

  static Future<Map<String, String>?> headersFor(String value) async {
    final uri = Uri.tryParse(value);
    final base = Uri.parse(EndPoints.baseUrl);
    if (uri == null ||
        uri.scheme != base.scheme ||
        uri.host != base.host ||
        uri.port != base.port) {
      return null;
    }
    final token = await SessionManager.instance.getAccessToken();
    return token?.trim().isNotEmpty == true
        ? {'Authorization': 'Bearer ${token!.trim()}'}
        : null;
  }

  static String _replaceLocalHost(Uri uri, Uri base) {
    if (uri.host != '127.0.0.1' && uri.host != 'localhost') {
      return uri.toString();
    }
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: uri.path,
      query: uri.hasQuery ? uri.query : null,
      fragment: uri.hasFragment ? uri.fragment : null,
    ).toString();
  }
}
