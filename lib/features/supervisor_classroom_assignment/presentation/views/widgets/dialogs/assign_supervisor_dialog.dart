import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/presentation/models/supervisor_assignment_ui_data.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignSupervisorDialog extends StatefulWidget {
  const AssignSupervisorDialog({super.key, required this.supervisorName});

  final String supervisorName;

  @override
  State<AssignSupervisorDialog> createState() => AssignSupervisorDialogState();
}

class AssignSupervisorDialogState extends State<AssignSupervisorDialog> {
  final formKey = GlobalKey<FormState>();
  String? selectedClassroom;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return CustomAppDialog(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDialogHeader(
                title: s.assignSupervisorToClassroom(widget.supervisorName),
              ),
              const SizedBox(height: 16),
              CustomDropdownFormField(
                label: s.classrooms,
                hint: s.chooseClassroom,
                value: selectedClassroom,
                items: supervisorClassroomOptions(s),
                isRequired: true,
                labelColor: ColorManager.mainColor14,
                hintStyle: StylesManager.styleRegular16(
                  context,
                ).copyWith(color: ColorManager.greyA8AF),
                validator: (value) => value == null ? s.fieldRequired : null,
                onChanged: (value) {
                  setState(() => selectedClassroom = value);
                },
              ),
              const SizedBox(height: 16),
              CustomAppButton(text: s.save, onPressed: submit),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (!(formKey.currentState?.validate() ?? false)) return;
    Navigator.pop(context);
  }
}
