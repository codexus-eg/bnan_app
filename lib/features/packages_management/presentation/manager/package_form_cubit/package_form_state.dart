import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_type.dart';

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
  bool get isGulf => registrationMode?.trim().toLowerCase() == 'gulf';
  bool get isEgyptian => registrationMode?.trim().toLowerCase() == 'egyptian';
  bool get isEgyptianAllSubjects => isEgyptian && !isSingleSubject;
  String get effectivePackageType => isGulf || isSingleSubject
      ? PackageType.hours
      : isEgyptianAllSubjects
      ? PackageType.monthly
      : packageType;
  bool get canSelectSingleSubject => isEgyptian;
  bool get isSingleSubject => accessScope == PackageAccessScope.singleSubject;
}
