import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/users_management/data/models/user_model.dart';
import 'package:bnan_app/features/users_management/presentation/manager/users_management_cubit/users_management_cubit.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_fields.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/form_mode.dart';
import 'package:bnan_app/features/users_management/presentation/widgets/dialogs/dialog_error_message.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormDialog extends StatefulWidget {
  const FormDialog.add({super.key}) : mode = FormMode.add, user = null;

  const FormDialog.edit({super.key, required this.user}) : mode = FormMode.edit;

  const FormDialog.resetPassword({super.key, required this.user})
    : mode = FormMode.password;

  final FormMode mode;
  final UserItem? user;

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  bool obscurePassword = true;
  String? curriculumId;

  void _togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user?.name ?? '');
    emailController = TextEditingController(text: widget.user?.email ?? '');
    phoneController = TextEditingController(text: widget.user?.phone ?? '');
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final cubit = context.read<UsersManagementCubit>();
    return BlocListener<UsersManagementCubit, UsersManagementState>(
      listener: _listenToActionState,
      child: CustomAppDialog(
        child: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(title: title(s)),
              const SizedBox(height: 16),
              Form(
                key: cubit.formKey,
                child: FormFields(
                  mode: widget.mode,
                  nameController: nameController,
                  emailController: emailController,
                  phoneController: phoneController,
                  passwordController: passwordController,
                  obscurePassword: obscurePassword,
                  onTogglePasswordVisibility: _togglePasswordVisibility,
                  curriculumId: curriculumId,
                  onCurriculumChanged: (value) {
                    setState(() => curriculumId = value);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildActions(context, s),
            ],
          ),
        ),
      ),
    );
  }

  String title(S s) {
    if (widget.mode == FormMode.add) return s.addNewUser;
    if (widget.mode == FormMode.edit) return s.editData;
    return s.resetPassword;
  }

  Widget _buildActions(BuildContext context, S s) {
    if (widget.mode != FormMode.add) {
      return _actionContent(context, s, canSave: true);
    }
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final canSave =
            !state.isLoadingCurriculums && state.curriculums.isNotEmpty;
        return _actionContent(context, s, canSave: canSave);
      },
    );
  }

  Widget _actionContent(BuildContext context, S s, {required bool canSave}) {
    return BlocBuilder<UsersManagementCubit, UsersManagementState>(
      builder: (context, state) {
        final isLoading =
            state is UsersActionLoading && _isCurrentAction(state.action);
        final failure =
            state is UsersActionFailure && _isCurrentAction(state.action)
            ? state.message
            : null;
        return Column(
          children: [
            if (failure != null) ...[
              DialogErrorMessage(message: failure),
              const SizedBox(height: 12),
            ],
            CustomAppButton(
              text: s.save,
              isLoading: isLoading,
              onPressed: canSave && !isLoading ? () => _onSave(context) : null,
            ),
          ],
        );
      },
    );
  }

  void _listenToActionState(BuildContext context, UsersManagementState state) {
    if (state is UsersActionSuccess && _isCurrentAction(state.action)) {
      Navigator.pop(context);
    }
  }

  bool _isCurrentAction(UsersManagementAction action) {
    return switch (widget.mode) {
      FormMode.add => action == UsersManagementAction.create,
      FormMode.edit => action == UsersManagementAction.update,
      FormMode.password => action == UsersManagementAction.password,
    };
  }

  Future<void> _onSave(BuildContext context) async {
    final cubit = context.read<UsersManagementCubit>();
    if (cubit.formKey.currentState?.validate() != true) return;

    if (widget.mode == FormMode.password) {
      await cubit.updateUserPassword(
        userId: widget.user?.id ?? '',
        password: passwordController.text,
      );
    } else if (widget.mode == FormMode.edit) {
      final user = _userFromFields(widget.user);
      await cubit.updateUser(userId: user.id, user: user);
    } else {
      await cubit.createUser(
        user: _userFromFields(),
        password: passwordController.text,
        curriculumId: curriculumId ?? '',
      );
    }
  }

  UserItem _userFromFields([UserItem? originalUser]) {
    return UserItem(
      id: originalUser?.id ?? '',
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      registrationDate: originalUser?.registrationDate ?? '',
      parentName: originalUser?.parentName ?? '',
      classes: originalUser?.classes ?? '',
      roles: originalUser?.roles ?? '',
      status: originalUser?.status ?? '',
      createdAt: originalUser?.createdAt ?? '',
      updatedAt: originalUser?.updatedAt ?? '',
      curriculum: originalUser?.curriculum ?? const [],
      grade: originalUser?.grade ?? const [],
      registrationMode: originalUser?.registrationMode ?? '',
    );
  }
}
