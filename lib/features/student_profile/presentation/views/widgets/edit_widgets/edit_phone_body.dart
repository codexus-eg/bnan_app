import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/bnan_footer.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/shared_widgets/custom_auth_text_field.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_phone_cubit/update_phone_cubit.dart';
import 'package:bnan_app/features/student_profile/presentation/manager/update_phone_cubit/update_phone_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPhoneBody extends StatelessWidget {
  const EditPhoneBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdatePhoneCubit>();

    return BlocConsumer<UpdatePhoneCubit, UpdatePhoneState>(
      listener: (context, state) {
        if (state is UpdatePhoneSuccess) {
          showCustomSnackBar(context, state.message, true);
Navigator.pop(context, true);        }
        if (state is UpdatePhoneFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdatePhoneLoading;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomAuthTextField(
                  controller: cubit.phoneController,
                  label: S.of(context).changePhoneTitle,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: S.of(context).confirm,
                  isLoading: isLoading,
                  onPressed: () {
                    if (isLoading) return;
                    cubit.updatePhone();
                  },
                ),
                const Spacer(),
                const BnanFooter(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
