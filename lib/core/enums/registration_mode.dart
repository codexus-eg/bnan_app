enum RegistrationMode {
  egyptian,
  gulf;

  static RegistrationMode? fromValue(Object? value) {
    final normalized = value?.toString().trim().toLowerCase();
    for (final mode in RegistrationMode.values) {
      if (mode.name == normalized) return mode;
    }
    return null;
  }

  static List<RegistrationMode> fromList(Object? value) {
    if (value is! List) return const [];
    return value
        .map(fromValue)
        .whereType<RegistrationMode>()
        .toSet()
        .toList(growable: false);
  }
}
