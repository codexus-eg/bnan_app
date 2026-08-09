class RegisterFlowArgsModel {
  final String curriculumId;
  final String curriculumName;
  final String packageId;
  final String packageName;
  final String packagePrice;
  final String packageCurrency;
  final String? registrationMode;
  final String accessScope;

  const RegisterFlowArgsModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.packageCurrency,
    this.registrationMode,
    this.accessScope = 'all_subjects',
  });

  bool get isGulf => registrationMode == 'gulf';
  bool get isSingleSubject => accessScope == 'single_subject';
}
