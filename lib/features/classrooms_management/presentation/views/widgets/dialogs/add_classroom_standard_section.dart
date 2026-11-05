import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/academic_lookup_dropdowns.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AddClassroomStandardSection extends StatelessWidget {
  const AddClassroomStandardSection({
    super.key,
    required this.meetingLinkController,
    required this.onSelectionChanged,
  });

  final TextEditingController meetingLinkController;
  final ValueChanged<AcademicLookupSelection> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      children: [
        CustomTextField(
          label: s.meetingLinkOptional,
          controller: meetingLinkController,
          keyboardType: TextInputType.url,
          backgroundColor: ColorManager.white,
        ),
        const SizedBox(height: 16),
        AcademicLookupDropdowns(
          showCurriculum: true,
          showGrade: true,
          showClassroom: false,
          showSubject: false,
          onSelectionChanged: onSelectionChanged,
        ),
      ],
    );
  }
}
