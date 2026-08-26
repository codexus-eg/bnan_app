import 'package:bnan_app/features/parent_children/presentation/widgets/parent_gulf_payment_fields.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalPaymentStep extends StatelessWidget {
  const RenewalPaymentStep({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentSubscriptionRenewalCubit>();
    final provider = context
        .watch<ParentSubscriptionRenewalCubit>()
        .state
        .selectedProvider;
    return ParentGulfPaymentFields(
      selectedProvider: provider,
      onChanged: cubit.selectPaymentProvider,
    );
  }
}
