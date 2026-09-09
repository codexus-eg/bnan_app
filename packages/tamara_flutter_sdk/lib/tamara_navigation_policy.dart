abstract final class TamaraNavigationPolicy {
  static bool matches(String url, String expectedUrl) {
    final actual = Uri.tryParse(url);
    final expected = Uri.tryParse(expectedUrl);
    if (actual == null || expected == null || !actual.hasAuthority) {
      return false;
    }
    if (actual.host.toLowerCase() != expected.host.toLowerCase()) {
      return false;
    }
    final actualPath = _normalizedPath(actual);
    final expectedPath = _normalizedPath(expected);
    if (actualPath == expectedPath) return true;

    if (expectedPath.startsWith('/api/v1')) {
      return actualPath == expectedPath.substring('/api/v1'.length);
    }
    return actualPath == '/api/v1$expectedPath';
  }

  static String _normalizedPath(Uri uri) {
    final path = uri.path;
    return path.length > 1 && path.endsWith('/')
        ? path.substring(0, path.length - 1)
        : path;
  }
}
