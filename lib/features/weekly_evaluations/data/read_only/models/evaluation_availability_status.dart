enum EvaluationAvailabilityStatus {
  evaluated,
  notEvaluated,
  notAvailable,
  unknown;

  static EvaluationAvailabilityStatus parse(
    Object? value, {
    required bool hasSubject,
    required bool hasEvaluation,
  }) {
    final status = value?.toString().trim().toLowerCase() ?? '';
    if (status.isNotEmpty) {
      return switch (status) {
        'evaluated' => evaluated,
        'not_evaluated' => notEvaluated,
        'not_available' => notAvailable,
        _ => unknown,
      };
    }
    if (hasEvaluation) return evaluated;
    return hasSubject ? notEvaluated : notAvailable;
  }
}
