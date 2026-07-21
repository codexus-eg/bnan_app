import 'package:bnan_app/features/certificates_management/data/models/requests/update_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/update_monthly_certificate_cubit/update_monthly_certificate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateMonthlyCertificateCubit
    extends Cubit<UpdateMonthlyCertificateState> {
  UpdateMonthlyCertificateCubit(this.repo)
    : super(UpdateMonthlyCertificateInitial());

  final CertificatesManagementRepo repo;

  Future<void> updateMonthlyCertificate({
    required String certificateId,
    required UpdateMonthlyCertificateRequestModel request,
  }) async {
    emit(UpdateMonthlyCertificateLoading());

    final result = await repo.updateMonthlyCertificate(
      certificateId: certificateId,
      request: request,
    );

    result.fold(
      (failure) => emit(UpdateMonthlyCertificateFailure(failure.message)),
      (response) => emit(UpdateMonthlyCertificateSuccess(response)),
    );
  }
}
