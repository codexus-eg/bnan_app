import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/splash_and_onboarding/data/models/onboarding_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_state.dart';
import 'package:flutter/material.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final PageController pageController = PageController();

  final List<OnboardingModel> pages = [
    OnboardingModel(
      imagePath: ImageManager.onboarding1,
      title: S.current.onboardingTitle1,
      description: S.current.onboardingSubtitle1,
    ),
    OnboardingModel(
      imagePath: ImageManager.onboarding2,
      title: S.current.onboardingTitle2,
      description: S.current.onboardingSubtitle2,
    ),
    OnboardingModel(
      imagePath: ImageManager.onboarding3,
      title: S.current.onboardingTitle3,
      description: S.current.onboardingSubtitle3
    ,
    ),
  ];

  OnboardingCubit() : super(const OnboardingState(currentPage: 0));

  void onPageChanged(int index) {
    emit(OnboardingState(currentPage: index));
  }

  void nextPage(BuildContext context) {
    if (state.currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding(context);
    }
  }

  void skip(BuildContext context) {
    finishOnboarding(context);
  }

  void finishOnboarding(BuildContext context) {
    MyNavigator.goToOff(context, Routes.logIn);
  }
}
