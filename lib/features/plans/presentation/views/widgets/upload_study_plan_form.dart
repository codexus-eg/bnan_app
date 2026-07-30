import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UploadStudyPlanForm extends StatefulWidget {
  const UploadStudyPlanForm({super.key});

  @override
  State<UploadStudyPlanForm> createState() => _UploadStudyPlanFormState();
}

class _UploadStudyPlanFormState extends State<UploadStudyPlanForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDialogHeader(title: s.uploadStudyPlan),
          const SizedBox(height: 16),
          _dropdown(s.grade, s.chooseGrade, {
            'first': s.firstPrimaryClassroom,
            'second': s.secondPrimaryClassroom,
          }),
          const SizedBox(height: 12),
          _dropdown(s.week, s.selectWeek, {
            'week1': s.weekOne,
            'week2': s.weekTwo,
          }),
          const SizedBox(height: 12),
          CustomFilePickerField(
            label: s.planFile,
            hint: s.chooseFile,
            // TODO: Connect file selection and upload in the API phase.
            onTap: () {},
          ),
          const SizedBox(height: 16),
          CustomAppButton(text: s.uploadAction, onPressed: _submit),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String hint, Map<String, String> labels) {
    return CustomDropdownFormField(
      label: label,
      hint: hint,
      items: labels.keys.toList(),
      itemsLabels: labels,
      isRequired: true,
      onChanged: (_) {},
      validator: (value) => MyValidator.requiredField(value, label),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context);
    }
  }
}
