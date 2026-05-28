import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/onboarding_cubit/onboarding_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/onboarding_cubit/onboarding_state.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/views/widgets/onboarding_widgets/onboarding_content.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/views/widgets/onboarding_widgets/onboarding_skip_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingBody extends StatelessWidget {
  const OnboardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();

        return SafeArea(
          right: false,
          left: false,
          child: Column(
            children: [
              OnboardingSkipButton(onPressed: () => cubit.skip(context)),
              Expanded(
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: cubit.pageController,
                  itemCount: cubit.pages.length,
                  onPageChanged: cubit.onPageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingContent(
                      data: cubit.pages[index],
                      isLast: state.currentPage == cubit.pages.length - 1,
                      onPressed: () => cubit.nextPage(context),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
