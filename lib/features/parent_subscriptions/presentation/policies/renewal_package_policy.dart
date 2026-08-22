import 'package:bnan_app/features/packages_management/data/models/egyptian_package_policy.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';

abstract class RenewalPackagePolicy {
  static bool isVisible(
    PackageModel package, {
    required String registrationMode,
    required String curriculumId,
    String currentAccessScope = '',
    String currentPackageType = '',
  }) {
    final valid =
        package.isActive &&
        ParentPackagePolicy.isRegistrationModeSupported(registrationMode) &&
        package.curriculum == curriculumId &&
        (registrationMode != 'egyptian' ||
            EgyptianPackagePolicy.isValid(package));
    final isEgyptianPrivate =
        registrationMode == 'egyptian' &&
        currentAccessScope == 'single_subject' &&
        currentPackageType == 'hours';
    return valid &&
        (!isEgyptianPrivate ||
            package.accessScope == 'single_subject' && package.type == 'hours');
  }
}
