class NameHelper {
  static String getFirstTwoNames(String? fullName) {
    if (fullName == null || fullName.trim().isEmpty) return '';

    final names = fullName.trim().split(RegExp(r'\s+'));

    if (names.length == 1) return names.first;

    return '${names[0]} ${names[1]}';
  }
}