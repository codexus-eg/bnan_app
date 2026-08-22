import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/egyptian_package_policy.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';

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
    if (registrationMode == 'egyptian') {
      return EgyptianPackagePolicy.isValid(package);
    }
    if (package.accessScope != PackageAccessScope.singleSubject) return true;
    return false;
  }

  static bool isVisible(
    PackageModel package, {
    required String? registrationMode,
  }) => isValid(package, registrationMode: registrationMode);
}
