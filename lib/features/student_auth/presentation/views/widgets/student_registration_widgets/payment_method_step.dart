import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:bnan_app/features/payments/presentation/widgets/discount_preview_field.dart';
import 'package:bnan_app/features/payments/presentation/widgets/discount_preview_summary.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final selectedProvider = context.select(
      (RegisterCubit value) => value.selectedProvider,
    );
    final paymentCubit = context.watch<TamaraPaymentCubit>();
    final preview = context.watch<DiscountPreviewCubit>().state;
    final previewRequest = cubit.buildDiscountPreviewRequest();
    final previewOriginal =
        previewRequest != null && preview.matches(previewRequest.fingerprint)
        ? preview.summary?.originalAmount
        : null;
    final total = previewOriginal ?? cubit.checkoutOriginalAmount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   S.of(context).paymentMethod,
        //   style: StylesManager.styleBold16(
        //     context,
        //   ).copyWith(color: ColorManager.mainColor15),
        // ),
        // const SizedBox(height: 16),
        PaymentMethodCard(
          packageName: cubit.packageName,
          price: cubit.packagePrice,
          studentsCount: cubit.checkoutItemCount.toString(),
          total: cubit.formatAmount(total),
          currency: cubit.packageCurrency,
          quantityLabel: cubit.isItemizedCheckout
              ? cubit.checkoutItemCount == 1
                    ? S.of(context).subject
                    : S.of(context).subjects
              : null,
          quantityFirst: cubit.isItemizedCheckout,
        ),
        if (cubit.isGulf) ...[
          const SizedBox(height: 16),
          DiscountPreviewField(
            controller: cubit.discountCodeController,
            request: cubit.buildDiscountPreviewRequest,
            onChanged: (_) => paymentCubit.invalidateAmountSummary(),
          ),
          DiscountPreviewSummary(request: cubit.buildDiscountPreviewRequest),
        ],
        const SizedBox(height: 16),
        if (cubit.isGulf)
          PaymentMethodsOptions(
            selectedProvider: selectedProvider,
            onChanged: (provider) {
              if (provider == selectedProvider) return;
              cubit.selectPaymentProvider(provider);
            },
          ),
        if (paymentCubit.state is TamaraPaymentVerificationPending) ...[
          const SizedBox(height: 12),
          Text(
            S.of(context).paymentVerificationPending,
            textAlign: TextAlign.center,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ],
      ],
    );
  }
}
