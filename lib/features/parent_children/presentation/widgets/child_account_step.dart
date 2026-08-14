import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/custom_password_field.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildAccountStep extends StatelessWidget {
  const ChildAccountStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ParentAddChildCubit>();
    final state = context.watch<ParentAddChildCubit>().state;
    final s = S.of(context);
    return Column(
      children: [
        CustomTextField(
          initialValue: state.fullName,
          label: s.studentName,
          isRequired: true,
          validator: MyValidator.validateName,
          onChanged: (value) => cubit.updateAccount(fullName: value),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          initialValue: state.email,
          label: s.studentEmail,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          validator: MyValidator.validateEmail,
          onChanged: (value) => cubit.updateAccount(email: value),
        ),
        const SizedBox(height: 16),
        CustomPasswordField(
          initialValue: state.password,
          label: s.studentPasswordField,
          onChanged: (value) => cubit.updateAccount(password: value),
        ),
      ],
    );
  }
}
