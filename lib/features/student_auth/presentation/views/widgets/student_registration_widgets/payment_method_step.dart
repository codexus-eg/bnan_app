import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/discount_code_field.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_discount_summary.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);
    final paymentSummary = context.watch<TamaraPaymentCubit>().paymentSummary;
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
          studentsCount: '1',
          total: cubit.packagePrice,
          currency: cubit.packageCurrency,
        ),
        if (cubit.isGulf) ...[
          const SizedBox(height: 16),
          const DiscountCodeField(),
          if (paymentSummary?.hasDiscount == true) ...[
            const SizedBox(height: 16),
            PaymentDiscountSummary(summary: paymentSummary!),
          ],
        ],
        const SizedBox(height: 16),
        const PaymentMethodsOptions(),
      ],
    );
  }
}
