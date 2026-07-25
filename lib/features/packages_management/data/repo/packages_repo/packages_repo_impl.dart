import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/network/api_consumer.dart';
import 'package:bnan_app/core/network/end_points.dart';
import 'package:bnan_app/core/network/repo_guard.dart';
import 'package:bnan_app/features/packages_management/data/models/get_packages_response_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_response_model.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:dartz/dartz.dart';

class PackagesRepoImpl implements PackagesRepo {
  const PackagesRepoImpl(this.apiConsumer);

  final ApiConsumer apiConsumer;

  @override
  Future<Either<Failure, GetPackagesResponseModel>> getPackages() {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.packages,
        isProtected: true,
      );

      return GetPackagesResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, PackageResponseModel>> getPackageById(
    String packageId,
  ) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.packageById(packageId),
        isProtected: true,
      );

      return PackageResponseModel.fromJson(asMap(response));
    });
  }

  @override
  Future<Either<Failure, GetPackagesResponseModel>> getPackagesByCurriculum(
    String curriculumId,
  ) {
    return repoGuard(() async {
      final response = await apiConsumer.get(
        EndPoints.packagesByCurriculum(curriculumId),
        isProtected: true,
      );

      return GetPackagesResponseModel.fromJson(asMap(response));
    });
  }
}