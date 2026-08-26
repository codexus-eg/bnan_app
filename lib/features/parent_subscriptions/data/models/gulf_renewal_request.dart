import 'package:bnan_app/features/parent_children/data/models/parent_payment_address.dart';
import 'package:bnan_app/features/payments/data/models/gulf_payment_provider.dart';

class GulfRenewalRequest {
  const GulfRenewalRequest({
    required this.subscriptionId,
    required this.packageId,
    required this.paymentAddress,
    this.provider = GulfPaymentProvider.tamara,
  });
  final String subscriptionId;
  final String packageId;
  final ParentPaymentAddress paymentAddress;
  final GulfPaymentProvider provider;

  Map<String, dynamic> toJson() => {
    'provider': provider.apiValue,
    'subscriptionId': subscriptionId.trim(),
    'packageId': packageId.trim(),
    if (provider == GulfPaymentProvider.tamara)
      'paymentAddress': paymentAddress.toJson(),
  };
}
