import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/shared_widgets/bnan_footer.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/update_name_cubit/update_name_cubit.dart';
import 'package:bnan_app/features/shared_profile/presentation/manager/update_name_cubit/update_name_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditNameBody extends StatelessWidget {
  const EditNameBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateNameCubit>();

    return BlocConsumer<UpdateNameCubit, UpdateNameState>(
      listener: (context, state) {
        if (state is UpdateNameSuccess) {
          showCustomSnackBar(context, state.message, true);
          Navigator.pop(context, true);
        }
        if (state is UpdateNameFailure) {
          showCustomSnackBar(context, state.errorMessage, false);
        }
      },
      builder: (context, state) {
        final isLoading = state is UpdateNameLoading;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: cubit.formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: cubit.nameController,
                  label: S.of(context).changeUsernameTitle,
                ),
                const SizedBox(height: 16),
                CustomAppButton(
                  text: S.of(context).confirm,
                  isLoading: isLoading,
                  onPressed: () {
                    if (isLoading) return;
                    cubit.updateName();
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
