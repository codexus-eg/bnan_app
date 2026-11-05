abstract final class EnvironmentValidator {
  static const Set<String> prodHosts = {
    'api.bnanacademysa.com',
    'bnanacademysa.com',
    'www.bnanacademysa.com',
    'socket.bnanacademysa.com',
  };

  static Uri validateStagingBase(String? raw) {
    final trimmed = raw?.trim() ?? '';
    if (trimmed.isEmpty) {
      throw StateError(
        'Staging requires a non-empty STAGING_BASE_URL or BASE_URL.',
      );
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        !['http', 'https'].contains(uri.scheme)) {
      throw StateError(
        'Invalid staging URL: "$trimmed". Must be a valid HTTP/HTTPS URL.',
      );
    }
    final host = uri.host.toLowerCase().trim();
    if (prodHosts.contains(host)) {
      throw StateError(
        'Staging URL cannot point to the production host ($host).',
      );
    }
    return uri;
  }

  static String resolveSocket(Uri baseUri, String? custom) {
    final trimmed = custom?.trim() ?? '';
    if (trimmed.isEmpty) return baseUri.origin;
    final socketUri = Uri.tryParse(trimmed);
    if (socketUri == null || !socketUri.hasScheme || !socketUri.hasAuthority) {
      throw StateError('Invalid staging socket URL: "$trimmed".');
    }
    final host = socketUri.host.toLowerCase().trim();
    if (prodHosts.contains(host)) {
      throw StateError(
        'Staging socket URL cannot point to the production host ($host).',
      );
    }
    return trimmed;
  }
}
