import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_type.dart';

abstract class EgyptianPackagePolicy {
  static bool isValid(PackageModel package) =>
      (package.accessScope == PackageAccessScope.allSubjects &&
          package.type == PackageType.monthly) ||
      (package.accessScope == PackageAccessScope.singleSubject &&
          package.type == PackageType.hours);
}
