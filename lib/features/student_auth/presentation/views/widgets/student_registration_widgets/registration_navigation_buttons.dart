import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
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
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';

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
            text: step == 5
                ? S.of(context).confirm
                : step == 4
                ? S.of(context).goToPayment
                : S.of(context).next,
            isLoading:
                registerState is RegisterLoading ||
                paymentState is TamaraPaymentLoading,
            onPressed: () async {
              final cubit = RegisterCubit.get(context);
              if (step == 5) {
                MyNavigator.goToOffAll(context, Routes.logIn);
                return;
              }
              if (!cubit.isGulf) {
                cubit.nextStep();
                return;
              }
              if (step == 1) {
                await context.read<TamaraPaymentCubit>().discardStaleAttempt();
                await cubit.authenticateParentAndContinue();
                if (context.mounted && cubit.state.currentStep == 2) {
                  await context
                      .read<TamaraPaymentCubit>()
                      .resumeAfterParentAuth();
                }
                return;
              }
              if (step == 3 && cubit.buildTamaraRequest() == null) {
                if (context.mounted) {
                  showCustomSnackBar(
                    context,
                    'يرجى استكمال البيانات المطلوبة',
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
          if (step > 1 && step < 5) ...[
            const SizedBox(height: 16),
            CustomAppButton(
              text: S.of(context).previous,
              backgroundColor: ColorManager.secondaryColor,
              textColor: ColorManager.mainColor14,
              onPressed: () async {
                await context.read<TamaraPaymentCubit>().discardStaleAttempt();
                if (!context.mounted) return;
                RegisterCubit.get(context).previousStep();
              },
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
        showCustomSnackBar(context, 'تعذر فتح رابط الدفع', false);
        return;
      }
      final cubit = context.read<TamaraPaymentCubit>();
      if (!cubit.claimCheckoutLaunch(url)) return;
      final result = await TamaraCheckoutLauncher.open(context, url);
      await cubit.completeCheckoutLaunch(opened: result.opened);
      if (!context.mounted) return;
      if (!result.opened) {
        showCustomSnackBar(context, 'تعذر فتح رابط الدفع', false);
      } else {
        await cubit.onForeground();
      }
      return;
    }
    if (state is TamaraPaymentResult &&
        state.status != PaymentStatus.completed) {
      showCustomSnackBar(context, state.status.name, false);
    }
  }
}
