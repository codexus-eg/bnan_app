enum AdminRenewalStatus {
  pending('pending'),
  confirmed('confirmed'),
  completed('completed'),
  rejected('rejected');

  const AdminRenewalStatus(this.apiValue);
  final String apiValue;

  static AdminRenewalStatus parse(Object? value) => values.firstWhere(
    (status) => status.apiValue == value?.toString().trim().toLowerCase(),
    orElse: () => pending,
  );
}
