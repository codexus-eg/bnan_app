import 'package:bnan_app/features/payments/data/models/discount_preview_request.dart';

abstract class DiscountPreviewRequests {
  static DiscountPreviewRequest registration(Map<String, dynamic> checkout) =>
      _fromCheckout('student_registration', checkout, false);

  static DiscountPreviewRequest addChild(Map<String, dynamic> checkout) =>
      _fromCheckout('parent_add_child', checkout, true);

  static DiscountPreviewRequest renewal(Map<String, dynamic> payload) =>
      DiscountPreviewRequest(
        purchaseType: 'subscription_renewal',
        payload: payload,
        isProtected: true,
      );

  static DiscountPreviewRequest subject(Map<String, dynamic> payload) =>
      DiscountPreviewRequest(
        purchaseType: 'subject_request',
        payload: payload,
        isProtected: true,
      );

  static DiscountPreviewRequest _fromCheckout(
    String type,
    Map<String, dynamic> checkout,
    bool protected,
  ) {
    final payload = Map<String, dynamic>.from(checkout)
      ..remove('provider')
      ..remove('paymentAddress')
      ..remove('locale');
    final student = Map<String, dynamic>.from(payload['student'] as Map)
      ..remove('password');
    payload['student'] = student;
    return DiscountPreviewRequest(
      purchaseType: type,
      payload: payload,
      isProtected: protected,
    );
  }
}
