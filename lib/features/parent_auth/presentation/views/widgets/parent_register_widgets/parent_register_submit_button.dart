import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/parent_auth/data/models/parent_register_request_model.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_cubit.dart';
import 'package:bnan_app/features/parent_auth/presentation/manager/parent_register_cubit/parent_register_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentRegisterSubmitButton extends StatelessWidget {
  const ParentRegisterSubmitButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.whatsappController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController whatsappController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ParentRegisterCubit, ParentRegisterState>(
      listener: (context, state) {
        if (state is ParentRegisterFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        } else if (state is ParentRegisterSuccess) {
          showCustomSnackBar(
            context,
            S.of(context).userCreatedSuccessfully,
            true,
          );
          MyNavigator.goToOffAll(context, Routes.parentHome);
        }
      },
      builder: (context, state) => CustomAppButton(
        text: S.of(context).next,
        isLoading: state is ParentRegisterLoading,
        onPressed: () => _submit(context),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;
    context.read<ParentRegisterCubit>().registerParent(
      ParentRegisterRequestModel(
        fullName: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        phone: phoneController.text,
        whatsappNumber: whatsappController.text,
      ),
    );
  }
}
