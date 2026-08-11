enum AdminSubjectRequestStatus {
  awaitingAdminApproval('awaiting_admin_approval'),
  pending('pending'),
  assigned('assigned'),
  rejected('rejected');

  const AdminSubjectRequestStatus(this.apiValue);
  final String apiValue;
}
