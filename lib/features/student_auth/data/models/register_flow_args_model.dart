class RegisterFlowArgsModel {
  final String curriculumId;
  final String curriculumName;
  final String packageId;
  final String packageName;
  final String packagePrice;
  final String packageCurrency;
  final String? registrationMode;
  final String accessScope;
  final String packageType;

  const RegisterFlowArgsModel({
    required this.curriculumId,
    required this.curriculumName,
    required this.packageId,
    required this.packageName,
    required this.packagePrice,
    required this.packageCurrency,
    this.registrationMode,
    this.accessScope = 'all_subjects',
    this.packageType = '',
  });

  bool get isGulf => _value(registrationMode) == 'gulf';
  bool get isSingleSubject => _value(accessScope) == 'single_subject';
  bool get isEgyptianPrivate =>
      _value(registrationMode) == 'egyptian' &&
      isSingleSubject &&
      _value(packageType) == 'hours';

  static String _value(String? value) => value?.trim().toLowerCase() ?? '';
}
