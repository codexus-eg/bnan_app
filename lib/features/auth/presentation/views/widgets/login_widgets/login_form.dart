import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:bnan_app/features/auth/presentation/manager/login_cubit/login_state.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = LoginCubit.get(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          showCustomSnackBar(
            context,
            '${S.of(context).loginWelcomeTitle} ${state.user.fullName}',
            true,
          );
          MyNavigator.goToOffAll(context, Routes.home);
        }
        if (state is LoginFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAuthTextField(
                controller: cubit.emailController,
                label: S.of(context).email,
                keyboardType: TextInputType.emailAddress,
                // validator: MyValidator.validateEmail,
              ),
              const SizedBox(height: 16),
              CustomAuthTextField(
                controller: cubit.passwordController,
                label: S.of(context).password,
                hintText: S.of(context).passwordHint,
                obscureText: cubit.isPasswordVisible,
                suffixIcon: IconButton(
                  onPressed: cubit.togglePasswordVisibility,
                  icon: Icon(
                    cubit.isPasswordVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 24,
                    color: ColorManager.greyA8AF,
                  ),
                ),
                // validator: MyValidator.validatePassword,
              ),
              TextButton(
                onPressed: () {
                  MyNavigator.goTo(context, Routes.forgetPassword);
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  S.of(context).forgotPassword,
                  style: StylesManager.styleBold12(
                    context,
                  ).copyWith(color: ColorManager.secondaryColor),
                ),
              ),
             CustomAppButton(
              isLoading: isLoading,
                text:  S.of(context).login,
                onPressed: cubit.login,
              ),
            ],
          ),
        );
      },
    );
  }
}
