sealed class DeleteMonthlyCertificateState {}

final class DeleteMonthlyCertificateInitial
    extends DeleteMonthlyCertificateState {}

final class DeleteMonthlyCertificateLoading
    extends DeleteMonthlyCertificateState {}

final class DeleteMonthlyCertificateSuccess
    extends DeleteMonthlyCertificateState {}

final class DeleteMonthlyCertificateFailure
    extends DeleteMonthlyCertificateState {
  final String message;

  DeleteMonthlyCertificateFailure(this.message);
}
