import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_top_section.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_state.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_navigation_buttons.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/registration_step_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegistrationBody extends StatelessWidget {
  const StudentRegistrationBody({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> stepHeaderText = [
      S.of(context).parentInfo,
      S.of(context).curriculumSelection,
      S.of(context).studentInfo,
      S.of(context).paymentMethod,
      S.of(context).paymentInfo,
    ];
    return SafeArea(
      bottom: false,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: RegistrationTopSection(
                  title: S.of(context).studentRegistrationForm,
                  subtitle: S.of(context).pleaseFillRequiredInfo,
                  currentStep: state.currentStep,
                  textColor: ColorManager.mainColor14,
                  listLength: 5,
                  stepHeader: stepHeaderText[state.currentStep-1],
                ),
              ),
              // const SliverToBoxAdapter(child: SizedBox(height: 16)),
              // SliverToBoxAdapter(
              //   child: RegistrationHeader(
              //     title: S.of(context).studentRegistrationForm,
              //     subtitle: S.of(context).pleaseFillRequiredInfo,
              //   ),
              // ),
              // SliverToBoxAdapter(
              //   child: RegistrationStepper(
              //     currentStep: state.currentStep,
              //     listLength: 5,
              //   ),
              // ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: RegistrationStepContent(
                    currentStep: state.currentStep,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: RegistrationNavigationButtons(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }
}
