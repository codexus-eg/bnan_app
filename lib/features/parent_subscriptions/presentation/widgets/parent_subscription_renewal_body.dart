import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_top_section.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_state.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_navigation.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_result.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_step_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentSubscriptionRenewalBody extends StatelessWidget {
  const ParentSubscriptionRenewalBody({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<
        ParentSubscriptionRenewalCubit,
        ParentSubscriptionRenewalState
      >(
        builder: (context, state) {
          if (state.phase != ParentRenewalPhase.editing &&
              state.phase != ParentRenewalPhase.submitting) {
            return RenewalResult(state: state);
          }
          final headers = [
            S.of(context).renewalCurrentSubscription,
            S.of(context).parentPackageStep,
            S.of(context).parentSubjectsStep,
            S.of(context).optionalDiscountCode,
            S.of(context).parentReviewStep,
            S.of(context).parentPaymentStep,
          ];
          return SafeArea(
            top: false,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: RegistrationTopSection(
                    title: S.of(context).renewSubscription,
                    subtitle: S.of(context).pleaseFillRequiredInfo,
                    currentStep: state.currentStep + 1,
                    listLength: 6,
                    stepHeader: headers[state.currentStep],
                    textColor: ColorManager.mainColor14,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: RenewalStepContent(step: state.currentStep),
                  ),
                ),
                if (state.errorMessage != null)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        state.errorMessage!,
                        style: StylesManager.styleRegular14(
                          context,
                        ).copyWith(color: ColorManager.red),
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                const SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(child: RenewalNavigation()),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      );
}
