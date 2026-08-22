import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/teacher_assigned_subject_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

Future<String?> showTeacherSessionSubjectPicker(
  BuildContext context,
  List<TeacherAssignedSubjectModel> subjects,
) => showDialog<String>(
  context: context,
  builder: (_) => _TeacherSessionSubjectDialog(subjects: subjects),
);

class _TeacherSessionSubjectDialog extends StatefulWidget {
  const _TeacherSessionSubjectDialog({required this.subjects});
  final List<TeacherAssignedSubjectModel> subjects;

  @override
  State<_TeacherSessionSubjectDialog> createState() =>
      _TeacherSessionSubjectDialogState();
}

class _TeacherSessionSubjectDialogState
    extends State<_TeacherSessionSubjectDialog> {
  String? selectedId;

  @override
  Widget build(BuildContext context) => CustomAppDialog(
    child: Padding(
      padding: const EdgeInsetsDirectional.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomDropdown(
            label: S.of(context).chooseSubject,
            value: selectedId,
            items: widget.subjects.map((item) => item.id).toList(),
            itemsLabels: {
              for (final item in widget.subjects) item.id: item.name,
            },
            useDefaultIcon: true,
            onChanged: (value) => setState(() => selectedId = value),
          ),
          const SizedBox(height: 20),
          CustomAppButton(
            text: S.of(context).startSession,
            onPressed: selectedId == null
                ? null
                : () => Navigator.pop(context, selectedId),
          ),
        ],
      ),
    ),
  );
}
