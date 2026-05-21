import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/features/splash/presentation/views/manager/splash_cubit.dart';
import 'package:bnan_app/features/splash/presentation/views/manager/splash_state.dart';
import 'package:bnan_app/features/splash/presentation/views/widgets/splash_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashNavigateToLogin) {
          GoRouter.of(context).go(Routes.logIn);
        } else if (state is SplashNavigateToHome) {
          GoRouter.of(context).go(Routes.logIn);
        }
      },
      child: const Scaffold(body: SplashBody()),
    );
  }
}
