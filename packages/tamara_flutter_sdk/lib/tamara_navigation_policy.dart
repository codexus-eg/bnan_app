abstract final class TamaraNavigationPolicy {
  static bool matches(String url, String expectedUrl) {
    final actual = Uri.tryParse(url);
    final expected = Uri.tryParse(expectedUrl);
    if (actual == null || expected == null || !actual.hasAuthority) {
      return false;
    }
    return actual.host.toLowerCase() == expected.host.toLowerCase() &&
        _normalizedPath(actual) == _normalizedPath(expected);
  }

  static String _normalizedPath(Uri uri) {
    final path = uri.path;
    return path.length > 1 && path.endsWith('/')
        ? path.substring(0, path.length - 1)
        : path;
  }
}
