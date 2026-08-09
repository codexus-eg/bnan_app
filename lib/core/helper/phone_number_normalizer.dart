abstract final class PhoneNumberNormalizer {
  static const _specs = {
    'EGP': (dial: '20', pattern: r'1[0125]\d{8}'),
    'SAR': (dial: '966', pattern: r'5\d{8}'),
    'AED': (dial: '971', pattern: r'5\d{8}'),
    'KWD': (dial: '965', pattern: r'[4569]\d{7}'),
    'QAR': (dial: '974', pattern: r'[3567]\d{7}'),
    'BHD': (dial: '973', pattern: r'[36]\d{7}'),
    'OMR': (dial: '968', pattern: r'[79]\d{7}'),
  };

  static String? normalize(String? value, {required String currency}) {
    final spec = _specs[currency.trim().toUpperCase()];
    if (spec == null || value == null) return null;
    var compact = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (!RegExp(r'^\+?\d+$').hasMatch(compact)) return null;
    if (compact.startsWith('+')) compact = compact.substring(1);
    if (compact.startsWith('00')) compact = compact.substring(2);

    late final String national;
    if (compact.startsWith(spec.dial)) {
      national = compact.substring(spec.dial.length);
    } else if (_specs.values.any((item) => compact.startsWith(item.dial))) {
      return null;
    } else {
      national = compact.startsWith('0') ? compact.substring(1) : compact;
    }
    if (!RegExp('^${spec.pattern}\$').hasMatch(national)) return null;
    return '+${spec.dial}$national';
  }
}
