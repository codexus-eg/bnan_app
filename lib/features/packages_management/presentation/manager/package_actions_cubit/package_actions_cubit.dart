import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/update_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/repo/package_actions_repo/package_actions_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_actions_cubit/package_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackageActionsCubit extends Cubit<PackageActionsState> {
  PackageActionsCubit(this.packageActionsRepo) : super(PackageActionsInitial());

  final PackageActionsRepo packageActionsRepo;

  Future<void> createPackage(AddPackageRequestModel model) async {
    if (isClosed || state is CreatePackageLoading) return;
    emit(CreatePackageLoading());

    final result = await packageActionsRepo.createPackage(model);
    if (isClosed) return;

    result.fold(
      (failure) => emit(CreatePackageFailure(failure.message)),
      (_) => emit(CreatePackageSuccess()),
    );
  }

  Future<void> updatePackage({
    required String packageId,
    required UpdatePackageRequestModel model,
  }) async {
    if (isClosed || state is UpdatePackageLoading) return;
    emit(UpdatePackageLoading());

    final result = await packageActionsRepo.updatePackage(
      packageId: packageId,
      model: model,
    );
    if (isClosed) return;

    result.fold(
      (failure) => emit(UpdatePackageFailure(failure.message)),
      (_) => emit(UpdatePackageSuccess()),
    );
  }

  Future<void> deletePackage(String packageId) async {
    if (isClosed || state is DeletePackageLoading) return;
    emit(DeletePackageLoading());

    final result = await packageActionsRepo.deletePackage(packageId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(DeletePackageFailure(failure.message)),
      (_) => emit(DeletePackageSuccess()),
    );
  }
}
