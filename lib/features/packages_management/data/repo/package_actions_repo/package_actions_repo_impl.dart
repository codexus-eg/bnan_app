import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/update_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/repo/package_actions_repo/package_actions_repo.dart';
import 'package:dartz/dartz.dart';

class PackageActionsRepoImpl implements PackageActionsRepo {
  const PackageActionsRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, void>> createPackage(
    AddPackageRequestModel model,
  ) {
    return repoGuard(() async {
      await apiConsumer.post(
        EndPoints.packages,
        data: model.toJson(),
        isProtected: true,
      );
    });
  }

  @override
  Future<Either<Failure, void>> updatePackage({
    required String packageId,
    required UpdatePackageRequestModel model,
  }) {
    return repoGuard(() async {
      await apiConsumer.patch(
        EndPoints.packageById(packageId),
        data: model.toJson(),
        isProtected: true,
      );
    });
  }

  @override
  Future<Either<Failure, void>> deletePackage(
    String packageId,
  ) {
    return repoGuard(() async {
      await apiConsumer.delete(
        EndPoints.packageById(packageId),
        isProtected: true,
      );
    });
  }
}