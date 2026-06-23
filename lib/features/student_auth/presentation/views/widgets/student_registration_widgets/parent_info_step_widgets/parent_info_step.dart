import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
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
          // Text(
          //   S.of(context).parentInfo,
          //   style: StylesManager.styleBold16(context).copyWith(
          //     color: ColorManager.mainColor15,
          //   ),
          // ),
          // const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.parentNameController,
            label: S.of(context).parentName,
            hintText: '',
            isRequired: true,
                    ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.parentEmailController,
            label: S.of(context).email,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.parentPhoneController,
            label: S.of(context).phoneNumber,
            keyboardType: TextInputType.phone,
            isRequired: true,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.parentWhatsappController,
            label: S.of(context).whatsappNumber,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: cubit.studentPasswordController,
            label: S.of(context).studentPassword,
            hintText: S.of(context).passwordHint,
            obscureText: true,
            isRequired: true,
            suffixIcon: const Icon(
              Icons.visibility_outlined,
              size: 24,
              color: ColorManager.greyA8AF,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              S.of(context).passwordWillBeUsed,
              textAlign: TextAlign.start,
              style: StylesManager.styleBold12(context).copyWith(
                color: ColorManager.grey7D7D,
              ),
            ),
          ),
        ],
      ),
    );
  }
}