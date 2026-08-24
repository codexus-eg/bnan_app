import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';

class GulfRenewalRequest {
  const GulfRenewalRequest({
    required this.subscriptionId,
    required this.packageId,
    required this.paymentAddress,
  });
  final String subscriptionId;
  final String packageId;
  final ParentPaymentAddress paymentAddress;

  Map<String, dynamic> toJson() => {
    'subscriptionId': subscriptionId.trim(),
    'packageId': packageId.trim(),
    'paymentAddress': paymentAddress.toJson(),
  };
}
