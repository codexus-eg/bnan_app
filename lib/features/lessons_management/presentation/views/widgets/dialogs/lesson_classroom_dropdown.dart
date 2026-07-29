import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonClassroomDropdown extends StatelessWidget {
  const LessonClassroomDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: S.of(context).classroom,
      hint: S.of(context).selectClassroom,
      items: const [],
      onChanged: null,
    );
  }
}
