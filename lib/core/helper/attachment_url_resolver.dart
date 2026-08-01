import 'package:bnan_app/core/network/end_points.dart';

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
