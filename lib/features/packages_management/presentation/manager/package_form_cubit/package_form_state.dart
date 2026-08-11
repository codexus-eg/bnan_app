import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';

class PackageFormState {
  const PackageFormState({
    this.curriculumId,
    this.packageId,
    this.packageType = 'hours',
    this.accessScope = PackageAccessScope.allSubjects,
    this.registrationMode,
    this.currency = 'SAR',
    this.isPopular = false,
  });

  final String? curriculumId;
  final String? packageId;
  final String packageType;
  final String accessScope;
  final String? registrationMode;
  final String currency;
  final bool isPopular;

  bool get isEdit => packageId?.isNotEmpty == true;
  bool get canSelectSingleSubject => registrationMode == 'egyptian';
  bool get isSingleSubject => accessScope == PackageAccessScope.singleSubject;
}
