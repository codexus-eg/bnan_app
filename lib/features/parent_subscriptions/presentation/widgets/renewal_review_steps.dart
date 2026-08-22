import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/discount_code_field.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_discount_summary.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';

class RenewalDiscountStep extends StatelessWidget {
  const RenewalDiscountStep({super.key});
  @override
  Widget build(BuildContext context) => DiscountCodeField(
    onChanged: context.read<ParentSubscriptionRenewalCubit>().updateDiscount,
  );
}

class RenewalPriceStep extends StatelessWidget {
  const RenewalPriceStep({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ParentSubscriptionRenewalCubit>().state;
    final package = state.package!;
    final price = _format(package.price ?? 0);
    return Column(
      children: [
        if (state.args.studentName.trim().isNotEmpty) ...[
          Text(
            state.args.studentName,
            style: StylesManager.styleBold16(context),
          ),
          const SizedBox(height: 12),
        ],
        PaymentMethodCard(
          packageName: package.name ?? '',
          price: price,
          studentsCount: '1',
          total: price,
          currency: package.currency,
        ),
        if (state.paymentSummary?.hasDiscount == true) ...[
          const SizedBox(height: 16),
          PaymentDiscountSummary(summary: state.paymentSummary!),
        ],
      ],
    );
  }

  String _format(num value) =>
      value % 1 == 0 ? value.toInt().toString() : value.toString();
}
