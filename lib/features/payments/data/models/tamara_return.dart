enum TamaraReturnOutcome { success, cancel, failure }

class TamaraReturn {
  const TamaraReturn(this.outcome);

  static const scheme = 'bnanacademy';
  static const host = 'payment';
  static const _prefix = 'tamara';

  final TamaraReturnOutcome outcome;

  static TamaraReturn? tryParse(Uri uri) {
    if (uri.scheme.toLowerCase() != scheme ||
        uri.host.toLowerCase() != host ||
        uri.pathSegments.length != 2 ||
        uri.pathSegments.first.toLowerCase() != _prefix) {
      return null;
    }
    final value = uri.pathSegments.last.toLowerCase();
    for (final outcome in TamaraReturnOutcome.values) {
      if (outcome.name == value) return TamaraReturn(outcome);
    }
    return null;
  }
}
