import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_methods_options.dart';
import 'package:flutter/material.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';

class PaymentMethodStep extends StatelessWidget {
  const PaymentMethodStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);
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
          packageName: cubit.isGulf
              ? cubit.packageName
              : S.of(context).package4Hours,
          price: cubit.isGulf ? cubit.packagePrice : '160',
          studentsCount: '1',
          total: cubit.isGulf ? cubit.packagePrice : '160',
        ),
        const SizedBox(height: 16),
        const PaymentMethodsOptions(),
      ],
    );
  }
}
