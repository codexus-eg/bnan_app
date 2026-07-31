import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_file_picker_field.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/plans_dialog_error_message.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class UploadStudyPlanFields extends StatelessWidget {
  const UploadStudyPlanFields({
    super.key,
    required this.classrooms,
    required this.classroomId,
    required this.subjectId,
    required this.subjectHint,
    required this.subjects,
    required this.fileName,
    required this.fileError,
    required this.onClassroomChanged,
    required this.onSubjectChanged,
    required this.onPickFile,
  });

  final List<PlanClassroomOption> classrooms;
  final String? classroomId, subjectId, fileName, fileError;
  final String subjectHint;
  final Map<String, String> subjects;
  final ValueChanged<String?> onClassroomChanged, onSubjectChanged;
  final VoidCallback onPickFile;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        _dropdown(
          label: s.classRoom,
          hint: s.chooseClassRoom,
          value: classroomId,
          labels: {for (final item in classrooms) item.id: item.name},
          onChanged: onClassroomChanged,
        ),
        const SizedBox(height: 12),
        _dropdown(
          key: ValueKey(classroomId),
          label: s.subject,
          hint: classroomId == null ? s.selectClassroomFirst : subjectHint,
          value: subjectId,
          labels: classroomId == null ? const {} : subjects,
          onChanged: onSubjectChanged,
        ),
        const SizedBox(height: 12),
        CustomFilePickerField(
          label: s.planFile,
          hint: fileName ?? s.chooseFile,
          hasFile: fileName != null,
          onTap: onPickFile,
        ),
        if (fileError != null) ...[
          const SizedBox(height: 8),
          PlansDialogErrorMessage(message: fileError!),
        ],
      ],
    );
  }

  Widget _dropdown({
    Key? key,
    required String label,
    required String hint,
    required String? value,
    required Map<String, String> labels,
    required ValueChanged<String?> onChanged,
  }) => CustomDropdownFormField(
    key: key,
    label: label,
    hint: hint,
    value: value,
    items: labels.keys.toList(),
    itemsLabels: labels,
    isRequired: true,
    onChanged: onChanged,
    validator: (value) => MyValidator.requiredField(value, label),
  );
}
