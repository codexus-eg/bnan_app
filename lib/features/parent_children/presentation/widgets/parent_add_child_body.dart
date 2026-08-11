import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_top_section.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_state.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_add_child_navigation.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_add_child_result.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_add_child_step_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentAddChildBody extends StatelessWidget {
  const ParentAddChildBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: BlocBuilder<ParentAddChildCubit, ParentAddChildState>(
        builder: (context, state) {
          if ({
            ParentAddChildPhase.pendingReview,
            ParentAddChildPhase.processingPayment,
            ParentAddChildPhase.paymentStatusUnknown,
            ParentAddChildPhase.completed,
            ParentAddChildPhase.failure,
          }.contains(state.phase)) {
            return ParentAddChildResult(state: state);
          }
          final headers = _headers(context);
          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child: RegistrationTopSection(
                  title: S.of(context).parentAddChildTitle,
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
                  child: ParentAddChildStepContent(step: state.currentStep),
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
                sliver: SliverToBoxAdapter(child: ParentAddChildNavigation()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  List<String> _headers(BuildContext context) => [
    S.of(context).parentChildAccountStep,
    S.of(context).grade,
    S.of(context).parentPackageStep,
    S.of(context).parentSubjectsStep,
    S.of(context).parentReviewStep,
    S.of(context).parentPaymentStep,
  ];
}
