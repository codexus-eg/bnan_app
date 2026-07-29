import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class LessonSubjectDropdown extends StatelessWidget {
  const LessonSubjectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      label: S.of(context).subject,
      hint: S.of(context).chooseSubject,
      items: const [],
      onChanged: null,
    );
  }
}
