import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentRegisterContactFields extends StatelessWidget {
  const ParentRegisterContactFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.whatsappController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController whatsappController;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        CustomTextField(
          label: s.parentName,
          hintText: s.parentNameHint,
          controller: nameController,
          isRequired: true,
          validator: MyValidator.validateName,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.emailAddress,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          validator: MyValidator.validateEmail,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.phoneNumber,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          isRequired: true,
          validator: (value) => MyValidator.requiredField(value, s.phoneNumber),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.whatsappNumber,
          controller: whatsappController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
