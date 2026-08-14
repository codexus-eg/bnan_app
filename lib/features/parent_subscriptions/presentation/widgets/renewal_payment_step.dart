import 'package:bnan_app/features/parent_children/presentation/widgets/parent_egyptian_payment_fields.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_gulf_payment_fields.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalPaymentStep extends StatelessWidget {
  const RenewalPaymentStep({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    final state = context.watch<ParentSubscriptionRenewalCubit>().state;
    return state.isGulf
        ? const ParentGulfPaymentFields()
        : ParentEgyptianPaymentFields(
            receipt: state.receipt,
            onReceiptChanged: (v) => cubit.updateEgyptian(receipt: v),
            onMethodChanged: (v) => cubit.updateEgyptian(method: v),
            onReferenceChanged: (v) => cubit.updateEgyptian(reference: v),
          );
  }
}
