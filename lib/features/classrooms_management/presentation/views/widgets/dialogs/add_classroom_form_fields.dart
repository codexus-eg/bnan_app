import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_kind_toggle.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_standard_section.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/add_classroom_supervisor_field.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_form_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/shared_classroom_section.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomFormFields extends StatelessWidget {
  const AddClassroomFormFields({
    super.key,
    required this.isShared,
    required this.nameController,
    required this.meetingLinkController,
    required this.sharedState,
    required this.supervisorId,
    required this.onKindChanged,
    required this.onStandardSelectionChanged,
    required this.onSupervisorChanged,
    required this.onGrade1Changed,
    required this.onGrade2Changed,
    required this.onPrimaryChanged,
    required this.onToggleSubject,
  });

  final bool isShared;
  final TextEditingController nameController, meetingLinkController;
  final SharedClassroomFormState sharedState;
  final String? supervisorId;
  final ValueChanged<bool> onKindChanged;
  final ValueChanged<AcademicLookupSelection> onStandardSelectionChanged;
  final ValueChanged<String?> onSupervisorChanged, onGrade1Changed, onGrade2Changed;
  final ValueChanged<int> onPrimaryChanged;
  final ValueChanged<String> onToggleSubject;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        AddClassroomKindToggle(isShared: isShared, onChanged: onKindChanged),
        const SizedBox(height: 16),
        CustomTextField(
          label: s.className,
          labelColor: ColorManager.mainColor14,
          controller: nameController,
          backgroundColor: ColorManager.white,
          validator: (v) => v?.trim().isEmpty ?? true ? s.classNameRequired : null,
        ),
        const SizedBox(height: 16),
        if (!isShared)
          AddClassroomStandardSection(meetingLinkController: meetingLinkController, onSelectionChanged: onStandardSelectionChanged)
        else
          SharedClassroomSection(state: sharedState, onGrade1Changed: onGrade1Changed, onGrade2Changed: onGrade2Changed, onPrimaryChanged: onPrimaryChanged, onToggleSubject: onToggleSubject),
        const SizedBox(height: 16),
        AddClassroomSupervisorField(value: supervisorId, onChanged: onSupervisorChanged),
      ],
    );
  }
}
