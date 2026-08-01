import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_cubit.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/manager/splash_cubit/splash_state.dart';
import 'package:bnan_app/features/splash_and_onboarding/presentation/views/widgets/splash_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToOnboarding) {
          GoRouter.of(context).go(Routes.onboarding);
        } else if (state is SplashNavigateToHome) {
          GoRouter.of(context).go(state.route);
        }
      },
      child: const Scaffold(body: SplashBody()),
    );
  }
}
