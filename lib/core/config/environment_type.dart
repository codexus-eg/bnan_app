enum EnvironmentType {
  production,
  staging;

  static EnvironmentType parse(String? raw) {
    final value = raw?.trim().toLowerCase() ?? '';
    if (value.isEmpty || value == 'production' || value == 'prod') {
      return EnvironmentType.production;
    }
    if (value == 'staging' || value == 'stage') {
      return EnvironmentType.staging;
    }
    throw StateError(
      'Unknown environment "$raw". Allowed values: production, prod, staging, stage.',
    );
  }
}
