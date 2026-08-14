import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/discount_code_field.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_discount_summary.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/payment_method_card.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_review_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentPriceReviewStep extends StatelessWidget {
  const ParentPriceReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ParentAddChildCubit>().state;
    final package = state.package!;
    final price = _format(package.price ?? 0);
    return Column(
      children: [
        const ParentReviewDetails(),
        const SizedBox(height: 8),
        PaymentMethodCard(
          packageName: package.name ?? '',
          price: price,
          studentsCount: '1',
          total: price,
          currency: package.currency,
        ),
        const SizedBox(height: 16),
        DiscountCodeField(
          onChanged: context.read<ParentAddChildCubit>().updateDiscount,
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
