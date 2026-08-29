import 'package:bnan_app/features/parent_auth/presentation/views/widgets/parent_register_widgets/parent_register_contact_fields.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/core/shared_widget/custom_password_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentInfoStep extends StatelessWidget {
  const ParentInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);

    return Form(
      key: cubit.parentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ParentRegisterContactFields(
            nameController: cubit.parentNameController,
            emailController: cubit.parentEmailController,
            phoneController: cubit.parentPhoneController,
            whatsappController: cubit.parentWhatsappController,
          ),
          const SizedBox(height: 16),
          CustomPasswordField(
            controller: cubit.parentPasswordController,
            label: S.of(context).password,
            hintText: S.of(context).passwordHint,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).passwordWillBeUsed,
              textAlign: TextAlign.start,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.grey7D7D),
            ),
          ),
        ],
      ),
    );
  }
}
