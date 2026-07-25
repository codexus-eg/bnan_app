abstract class PackageActionsState {}

class PackageActionsInitial extends PackageActionsState {}

class CreatePackageLoading extends PackageActionsState {}

class CreatePackageSuccess extends PackageActionsState {}

class CreatePackageFailure extends PackageActionsState {
  CreatePackageFailure(this.message);

  final String message;
}

class UpdatePackageLoading extends PackageActionsState {}

class UpdatePackageSuccess extends PackageActionsState {}

class UpdatePackageFailure extends PackageActionsState {
  UpdatePackageFailure(this.message);

  final String message;
}

class DeletePackageLoading extends PackageActionsState {}

class DeletePackageSuccess extends PackageActionsState {}

class DeletePackageFailure extends PackageActionsState {
  DeletePackageFailure(this.message);

  final String message;
}