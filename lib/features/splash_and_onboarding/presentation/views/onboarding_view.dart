import 'package:bnan_app/features/splash_and_onboarding/presentation/views/widgets/onboarding_widgets/onboarding_body.dart';
import 'package:flutter/material.dart';


class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingBody(),
    );
  }
}
