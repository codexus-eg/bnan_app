class PackageFormState {
  String? curriculumId;
  String packageType;
  String currency;
  bool isPopular;

  PackageFormState({
    this.curriculumId,
    this.packageType = 'hours',
    this.currency = 'SAR',
    this.isPopular = false,
  });
}