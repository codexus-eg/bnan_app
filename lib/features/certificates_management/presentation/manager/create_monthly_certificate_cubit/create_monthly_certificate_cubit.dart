import 'package:bnan_app/features/certificates_management/data/models/requests/create_monthly_certificate_request_model.dart';
import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/create_monthly_certificate_cubit/create_monthly_certificate_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMonthlyCertificateCubit
    extends Cubit<CreateMonthlyCertificateState> {
  CreateMonthlyCertificateCubit(this.repo)
    : super(CreateMonthlyCertificateInitial());

  final CertificatesManagementRepo repo;

  Future<void> createMonthlyCertificate({
    required CreateMonthlyCertificateRequestModel request,
  }) async {
    emit(CreateMonthlyCertificateLoading());

    final result = await repo.createMonthlyCertificate(request: request);

    result.fold(
      (failure) => emit(CreateMonthlyCertificateFailure(failure.message)),
      (response) => emit(CreateMonthlyCertificateSuccess(response)),
    );
  }
}
