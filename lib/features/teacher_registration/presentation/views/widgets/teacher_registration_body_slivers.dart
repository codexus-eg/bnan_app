import 'package:bnan_app/core/shared_widget/custom_registration_widgets/custom_text_span_login.dart';
import 'package:bnan_app/core/shared_widget/custom_registration_widgets/registration_top_section.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_state.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_register_step_buttons.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_registration_step_content.dart';
import 'package:bnan_app/features/teacher_registration/presentation/views/widgets/teacher_steps_header_text.dart';
import 'package:flutter/material.dart';

class TeacherRegistrationBodySlivers extends StatelessWidget {
  const TeacherRegistrationBodySlivers({
    super.key,
    required this.state,
    required this.onNext,
    required this.isLoading,
  });

  final TeacherRegistrationState state;
  final VoidCallback? onNext;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final steps = teacherStepsHeaderText(context);

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: RegistrationTopSection(
            title: steps.title,
            subtitle: steps.subtitle,
            currentStep: state.currentStep,
            listLength: steps.headers.length,
            stepHeader:
                '${state.currentStep}/${steps.headers.length} - ${steps.headers[state.currentStep - 1]}',
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: TeacherRegistrationStepContent(
              currentStep: state.currentStep,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: TeacherRegisterStepButtons(
              currentStep: state.currentStep,
              stepsCount: steps.headers.length,
              isLoading: isLoading,
              onNext: onNext,
              onPrevious: TeacherRegistrationCubit.get(context).previousStep,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        const SliverToBoxAdapter(child: CustomTextSpanLogin()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20 ,
          ),
        ),
      ],
    );
  }
}
