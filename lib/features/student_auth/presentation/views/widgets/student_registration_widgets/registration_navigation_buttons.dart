import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_checkout_launcher.dart';
import 'package:bnan_app/features/payments/presentation/views/tamara_sdk_checkout_view.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_back_handler.dart';

class RegistrationNavigationButtons extends StatelessWidget {
  const RegistrationNavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final registerState = context.watch<RegisterCubit>().state;
    final step = registerState.currentStep;
    return BlocConsumer<TamaraPaymentCubit, TamaraPaymentState>(
      listener: _paymentListener,
      builder: (context, paymentState) => Column(
        children: [
          CustomAppButton(
            backgroundColor: step == 4 ? ColorManager.orangeED : null,
            text: !RegisterCubit.get(context).isGulf && step == 4
                ? S.of(context).submitRegistrationRequest
                : RegisterCubit.get(context).isGulf &&
                      step == 4 &&
                      paymentState is TamaraPaymentVerificationPending
                ? S.of(context).parentRetryPayment
                : step == 4
                ? S.of(context).payWithTamara
                : S.of(context).next,
            isLoading:
                registerState is RegisterLoading ||
                paymentState is TamaraPaymentLoading,
            onPressed: () async {
              final cubit = RegisterCubit.get(context);
              if (!cubit.isGulf) {
                if (step == 1) {
                  await cubit.authenticateParentAndContinue();
                  return;
                }
                if (step == 3 && !cubit.validateStudent()) {
                  showCustomSnackBar(
                    context,
                    S.of(context).errorValidation,
                    false,
                  );
                  return;
                }
                if (step == 4) {
                  final request = cubit.buildRegisterRequest();
                  if (request != null) await cubit.register(request: request);
                  return;
                }
                cubit.nextStep();
                return;
              }
              if (step == 1) {
                await context.read<TamaraPaymentCubit>().discardStaleAttempt();
                await cubit.authenticateParentAndContinue();
                return;
              }
              if (step == 3 && cubit.buildTamaraRequest() == null) {
                if (context.mounted) {
                  showCustomSnackBar(
                    context,
                    S.of(context).errorValidation,
                    false,
                  );
                }
                return;
              }
              if (step == 4) {
                final request = cubit.buildTamaraRequest(validateForm: false);
                if (request != null) {
                  await context.read<TamaraPaymentCubit>().checkout(request);
                }
                return;
              }
              cubit.nextStep();
            },
          ),
          if (step > 1) ...[
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).previous,
              backgroundColor: ColorManager.secondaryColor,
              textColor: ColorManager.mainColor14,
              onPressed: () => RegistrationBackHandler.previous(context),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _paymentListener(
    BuildContext context,
    TamaraPaymentState state,
  ) async {
    if (state is TamaraPaymentFailure) {
      showCustomSnackBar(context, state.message, false);
      return;
    }
    if (state is TamaraPaymentPending && state.shouldOpenCheckout) {
      final url = state.checkoutUrl;
      if (url == null) {
        showCustomSnackBar(
          context,
          S.of(context).parentUnableToOpenCheckout,
          false,
        );
        return;
      }
      final cubit = context.read<TamaraPaymentCubit>();
      if (!cubit.claimCheckoutLaunch(url)) return;
      final result = await TamaraCheckoutLauncher.open(
        context,
        url,
        completionStream: cubit.stream.map(
          (value) =>
              value is TamaraPaymentResult &&
              value.status == PaymentStatus.completed,
        ),
        isCompleted: () =>
            cubit.state is TamaraPaymentResult &&
            (cubit.state as TamaraPaymentResult).status ==
                PaymentStatus.completed,
        onPaymentSuccess: cubit.verifyProviderSuccess,
        onOpened: () => cubit.completeCheckoutLaunch(opened: true),
      );
      if (!context.mounted) return;
      if (!result.opened) {
        await cubit.completeCheckoutLaunch(opened: false);
        if (context.mounted) {
          showCustomSnackBar(
            context,
            S.of(context).parentUnableToOpenCheckout,
            false,
          );
        }
        return;
      }
      if (result.outcome == null) return;
      if (result.outcome == TamaraSdkOutcome.success) {
        await cubit.verifyCheckoutClosed();
      } else {
        await cubit.verifyCheckoutClosedOnce();
      }
      return;
    }
    if (state is TamaraPaymentVerificationPending) {
      showCustomSnackBar(
        context,
        S.of(context).paymentVerificationPending,
        true,
      );
      return;
    }
    if (state is TamaraPaymentResult &&
        const {
          PaymentStatus.failed,
          PaymentStatus.cancelled,
          PaymentStatus.expired,
        }.contains(state.status)) {
      showCustomSnackBar(context, S.of(context).parentPaymentFailed, false);
    }
  }
}
