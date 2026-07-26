class PackageFormState {
  const PackageFormState({
    this.curriculumId,
    this.packageId,
    this.packageType = 'hours',
    this.currency = 'SAR',
    this.isPopular = false,
  });

  final String? curriculumId;
  final String? packageId;
  final String packageType;
  final String currency;
  final bool isPopular;

  bool get isEdit => packageId?.isNotEmpty == true;
}
