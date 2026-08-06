class RegisterFlowArgsModel {
  final String curriculumId;
  final String curriculumName;
  final String packageId;
  final String packageName;
  final String packagePrice;
  final String packageCurrency;
  final String? registrationMode;

  const RegisterFlowArgsModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.packageCurrency,
    this.registrationMode,
  });

  bool get isGulf => registrationMode == 'gulf';
}
