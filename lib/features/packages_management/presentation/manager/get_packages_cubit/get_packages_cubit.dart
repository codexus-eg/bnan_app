import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPackagesCubit extends Cubit<GetPackagesState> {
  GetPackagesCubit(this.packagesRepo) : super(GetPackagesInitial());

  final PackagesRepo packagesRepo;

  Future<void> getPackages() async {
    emit(GetPackagesLoading());

    final result = await packagesRepo.getPackages();

    result.fold(
      (failure) => emit(GetPackagesFailure(failure.message)),
      (response) => emit(GetPackagesSuccess(response.data)),
    );
  }

  Future<void> getPackagesByCurriculum(String curriculumId) async {
    emit(GetPackagesLoading());

    final result = await packagesRepo.getPackagesByCurriculum(curriculumId);

    result.fold(
      (failure) => emit(GetPackagesFailure(failure.message)),
      (response) => emit(GetPackagesSuccess(response.data)),
    );
  }
}