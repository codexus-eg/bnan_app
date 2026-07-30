import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserRoleField extends StatelessWidget {
  const AddUserRoleField({super.key});

  static const _roles = ['supervisor', 'teacher'];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomDropdownFormField(
      label: s.userRole,
      value: context.read<UsersManagementCubit>().selectedRole,
      backgroundColor: ColorManager.white,
      items: _roles,
      itemsLabels: {'supervisor': s.supervisor, 'teacher': s.teacher},
      validator: (value) => MyValidator.requiredField(value, s.userRole),
      onChanged: (value) {
        if (value != null) {
          context.read<UsersManagementCubit>().setSelectedRole(value);
        }
      },
    );
  }
}
