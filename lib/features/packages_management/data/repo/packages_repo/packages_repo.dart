import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/features/packages_management/data/models/get_packages_response_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class PackagesRepo {
  Future<Either<Failure, GetPackagesResponseModel>> getPackages();

  Future<Either<Failure, PackageResponseModel>> getPackageById(
    String packageId,
  );

  Future<Either<Failure, GetPackagesResponseModel>> getPackagesByCurriculum(
    String curriculumId,
  );
}