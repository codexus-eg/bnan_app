import 'package:bnan_app/features/auth/presentation/views/manager/student_registration_cubit/student_registration_cubit.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/registration_header.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/registration_navigation_buttons.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/registration_step_content.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/registration_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentRegistrationBody extends StatelessWidget {
  const StudentRegistrationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: BlocBuilder<StudentRegistrationCubit, int>(
        builder: (context, step) {
          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              const SliverToBoxAdapter(child: RegistrationHeader()),
              SliverToBoxAdapter(
                child: RegistrationStepper(currentStep: step),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: RegistrationStepContent(currentStep: step),
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