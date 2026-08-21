import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_package_step.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_payment_step.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_review_steps.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_subject_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalStepContent extends StatelessWidget {
  const RenewalStepContent({super.key, required this.step});
  final int step;
  @override
  Widget build(BuildContext context) {
    final state = context.read<ParentSubscriptionRenewalCubit>().state;
    final args = state.args;
    return switch (step) {
      0 => ParentSubscriptionCard(
        child: ParentChildSubscriptionsModel(
          studentId: args.studentId,
          studentName: args.studentName,
          curriculumId: args.curriculumId,
          registrationMode: args.registrationMode,
          subscriptions: [args.subscription],
          subjects: args.subjects,
        ),
        subscription: args.subscription,
        showRenew: false,
        isParent: args.isParent,
      ),
      1 => const RenewalPackageStep(),
      2 => const RenewalSubjectStep(),
      3 =>
        state.isGulf ? const RenewalDiscountStep() : const RenewalPriceStep(),
      4 => state.isGulf ? const RenewalPriceStep() : const SizedBox.shrink(),
      _ => const RenewalPaymentStep(),
    };
  }
}
