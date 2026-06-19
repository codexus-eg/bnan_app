import 'package:bnan_app/features/student_auth/data/repo/auth_repo.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_packages_cubit/get_packages_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPackagesCubit extends Cubit<GetPackagesState> {
  GetPackagesCubit(this.authRepo) : super(GetPackagesInitial());

  final AuthRepo authRepo;

  static GetPackagesCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> getCurriculumPackages({required String curriculumId}) async {
    emit(GetPackagesLoading());

    final result = await authRepo.getCurriculumPackages(
      curriculumId: curriculumId,
    );

    result.fold(
      (failure) {
        emit(GetPackagesFailure(errorMessage: failure.message));
      },
      (response) {
        emit(GetPackagesSuccess(packages: response.packages));
      },
    );
  }
}
