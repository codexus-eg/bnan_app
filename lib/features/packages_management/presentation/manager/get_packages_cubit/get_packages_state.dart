import 'package:bnan_app/features/packages_management/data/models/package_model.dart';

abstract class GetPackagesState {}

class GetPackagesInitial extends GetPackagesState {}

class GetPackagesLoading extends GetPackagesState {}

class GetPackagesSuccess extends GetPackagesState {
  GetPackagesSuccess(this.packages);

  final List<PackageModel> packages;
}

class GetPackagesFailure extends GetPackagesState {
  GetPackagesFailure(this.message);

  final String message;
}
