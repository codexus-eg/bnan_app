import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_type.dart';

abstract class ParentPackagePolicy {
  static bool isRegistrationModeSupported(String? mode) =>
      mode == 'egyptian' || mode == 'gulf';

  static bool isValid(
    PackageModel package, {
    required String? registrationMode,
  }) {
    if (!package.isActive || !isRegistrationModeSupported(registrationMode)) {
      return false;
    }
    if (package.accessScope != PackageAccessScope.singleSubject) return true;
    return registrationMode == 'egyptian' && package.type == PackageType.hours;
  }

  static bool isVisible(
    PackageModel package, {
    required String? registrationMode,
  }) => isValid(package, registrationMode: registrationMode);
}
