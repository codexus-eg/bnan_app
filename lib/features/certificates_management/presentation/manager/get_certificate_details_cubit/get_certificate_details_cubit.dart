import 'package:bnan_app/features/certificates_management/data/repo/certificates_management_repo.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_certificate_details_cubit/get_certificate_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCertificateDetailsCubit extends Cubit<GetCertificateDetailsState> {
  GetCertificateDetailsCubit(this.repo) : super(GetCertificateDetailsInitial());

  final CertificatesManagementRepo repo;

  Future<void> getCertificateDetails({required String certificateId}) async {
    emit(GetCertificateDetailsLoading());

    final result = await repo.getCertificateById(certificateId: certificateId);

    result.fold(
      (failure) => emit(GetCertificateDetailsFailure(failure.message)),
      (response) => emit(GetCertificateDetailsSuccess(response)),
    );
  }
}
