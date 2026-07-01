import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/password_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class FormFields extends StatelessWidget {
  const FormFields({super.key, required this.mode, this.userName});

  final FormMode mode;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        if (mode != FormMode.password)
          CustomTextField(
            label: s.fullName,
            hintText: userName ?? 'شهد أحمد',
            hintStyle: getStyle(context),

            backgroundColor: ColorManager.white,
          ),
        if (mode == FormMode.add) ...[
          const SizedBox(height: 16),
          CustomTextField(
            label: s.email,
            hintText: 'sara@gmail.com',
            hintStyle: getStyle(context),

            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: s.phoneNumber,
            hintText: '0102222222222',
            hintStyle: getStyle(context),
            backgroundColor: ColorManager.white,
          ),
          const SizedBox(height: 16),
          CustomDropdownFormField(
            label: s.userRole,
            value: s.student,
            backgroundColor: ColorManager.white,
            items: [s.student, s.parentRole, s.supervisor],
            onChanged: (_) {},
          ),
        ],
        if (mode != FormMode.edit) ...[
          const SizedBox(height: 16),
          PasswordField(mode: mode),
        ],
      ],
    );
  }

  TextStyle getStyle(context) {
    return StylesManager.styleMedium14(
      context,
    ).copyWith(color: ColorManager.mainColor14);
  }
}
