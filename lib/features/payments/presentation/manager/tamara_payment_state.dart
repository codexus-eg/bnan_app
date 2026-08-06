import 'package:bnan_app/features/payments/data/models/payment_status.dart';

sealed class TamaraPaymentState {
  const TamaraPaymentState();
}

class TamaraPaymentInitial extends TamaraPaymentState {
  const TamaraPaymentInitial();
}

class TamaraPaymentLoading extends TamaraPaymentState {
  const TamaraPaymentLoading();
}

class TamaraPaymentPending extends TamaraPaymentState {
  const TamaraPaymentPending({
    this.checkoutUrl,
    this.shouldOpenCheckout = false,
  });
  final String? checkoutUrl;
  final bool shouldOpenCheckout;
}

class TamaraPaymentResult extends TamaraPaymentState {
  const TamaraPaymentResult({
    required this.status,
    this.studentLoggedIn = false,
  });

  final PaymentStatus status;
  final bool studentLoggedIn;
}

class TamaraPaymentFailure extends TamaraPaymentState {
  const TamaraPaymentFailure(this.message);
  final String message;
}
