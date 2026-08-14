import 'package:bnan_app/features/packages_management/data/models/package_type.dart';

bool canRenewSubscription({
  required String packageType,
  required String planKind,
  required num? remainingHours,
  required num? remainingValue,
  required DateTime? endDate,
  required String status,
  bool? serverAllowed,
}) {
  if (serverAllowed != null) return serverAllowed;
  final isHours =
      remainingHours != null ||
      packageType == PackageType.hours ||
      planKind == 'gulf';
  if (isHours && remainingHours != null) return remainingHours <= 0;
  final isMonthly =
      packageType == PackageType.monthly || planKind == 'egyptian_monthly';
  if (isMonthly || (!isHours && (endDate != null || remainingValue != null))) {
    if (endDate != null) return !endDate.isAfter(DateTime.now());
    if (remainingValue != null) return remainingValue <= 0;
  }
  return status == 'expired' || status == 'completed';
}
