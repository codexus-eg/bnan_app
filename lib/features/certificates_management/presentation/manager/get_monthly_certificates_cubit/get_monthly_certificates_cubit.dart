import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMonthlyCertificatesCubit extends Cubit<GetMonthlyCertificatesState> {
  GetMonthlyCertificatesCubit(this.repo)
      : super(GetMonthlyCertificatesInitial());

  final CertificatesManagementRepo repo;

  static GetMonthlyCertificatesCubit get(context) =>
      BlocProvider.of(context);

  Future<void> getMonthlyCertificates({
    String? gradeId,
  }) async {
    emit(GetMonthlyCertificatesLoading());

    final result = await repo.getMonthlyCertificates(
      gradeId: gradeId,
    );

    result.fold(
      (failure) => emit(GetMonthlyCertificatesFailure(failure.message)),
      (response) => emit(GetMonthlyCertificatesSuccess(response)),
    );
  }
}