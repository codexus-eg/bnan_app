enum EvaluationMode {
  egyptian,
  gulf,
  unknown;

  static EvaluationMode parse(Object? value) {
    return switch (value?.toString().trim().toLowerCase()) {
      'egyptian' => EvaluationMode.egyptian,
      'gulf' => EvaluationMode.gulf,
      _ => EvaluationMode.unknown,
    };
  }
}
