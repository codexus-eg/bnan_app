import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';

abstract class RenewalPackagePolicy {
  static bool isVisible(
    PackageModel package, {
    required String registrationMode,
    required String curriculumId,
  }) =>
      package.isActive &&
      ParentPackagePolicy.isRegistrationModeSupported(registrationMode) &&
      package.curriculum == curriculumId;
}
