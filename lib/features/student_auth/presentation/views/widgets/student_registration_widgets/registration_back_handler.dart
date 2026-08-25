import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract final class RegistrationBackHandler {
  static bool _handlingBack = false;

  static Future<void> previous(BuildContext context) async {
    if (_handlingBack) return;
    _handlingBack = true;
    try {
      final register = context.read<RegisterCubit>();
      if (register.state.currentStep <= RegisterCubit.firstStep) {
        await Navigator.maybePop(context);
        return;
      }
      final payment = context.read<TamaraPaymentCubit>();
      if (register.isGulf &&
          (payment.state is TamaraPaymentPending ||
              payment.state is TamaraPaymentLoading)) {
        await payment.abandonCheckout();
      }
      if (context.mounted) register.previousStep();
    } finally {
      _handlingBack = false;
    }
  }
}
