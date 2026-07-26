import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/update_package_request_model.dart';
import 'package:dartz/dartz.dart';

abstract class PackageActionsRepo {
  Future<Either<Failure, void>> createPackage(
    AddPackageRequestModel model,
  );

  Future<Either<Failure, void>> updatePackage({
    required String packageId,
    required UpdatePackageRequestModel model,
  });

  Future<Either<Failure, void>> deletePackage(
    String packageId,
  );
}