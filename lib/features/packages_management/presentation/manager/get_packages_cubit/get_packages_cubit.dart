import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPackagesCubit extends Cubit<GetPackagesState> {
  GetPackagesCubit(this.packagesRepo) : super(GetPackagesInitial());

  final PackagesRepo packagesRepo;
  int _requestVersion = 0;

  Future<void> getPackages() async {
    final version = ++_requestVersion;
    emit(GetPackagesLoading());

    final result = await packagesRepo.getPackages();
    if (isClosed || version != _requestVersion) return;

    result.fold(
      (failure) => emit(GetPackagesFailure(failure.message)),
      (response) => emit(GetPackagesSuccess(response.data)),
    );
  }

  Future<void> getPackagesByCurriculum(String curriculumId) async {
    final version = ++_requestVersion;
    emit(GetPackagesLoading());

    final result = await packagesRepo.getPackagesByCurriculum(curriculumId);
    if (isClosed || version != _requestVersion) return;

    result.fold(
      (failure) => emit(GetPackagesFailure(failure.message)),
      (response) => emit(
        GetPackagesSuccess(
          response.data.where((package) => package.isActive).toList(),
        ),
      ),
    );
  }
}
