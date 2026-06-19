import 'package:bnan_app/features/student_auth/data/models/package_model.dart';

abstract class GetPackagesState {}

class GetPackagesInitial extends GetPackagesState {}

class GetPackagesLoading extends GetPackagesState {}

class GetPackagesSuccess extends GetPackagesState {
  final List<PackageModel> packages;

  GetPackagesSuccess({required this.packages});
}

class GetPackagesFailure extends GetPackagesState {
  final String errorMessage;

  GetPackagesFailure({required this.errorMessage});
}