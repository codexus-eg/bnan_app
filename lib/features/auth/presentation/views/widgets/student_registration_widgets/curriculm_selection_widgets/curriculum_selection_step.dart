import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/auth/presentation/views/widgets/student_registration_widgets/custom_auth_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumSelectionStep extends StatefulWidget {
  const CurriculumSelectionStep({super.key});

  @override
  State<CurriculumSelectionStep> createState() =>
      _CurriculumSelectionStepState();
}

class _CurriculumSelectionStepState extends State<CurriculumSelectionStep> {
  String selectedCurriculum = '';

  @override
  Widget build(BuildContext context) {
    final curricula = [
      S.of(context).saudiCurriculum,
      S.of(context).egyptianCurriculum,
      S.of(context).qatariCurriculum,
    ];

    selectedCurriculum =
        selectedCurriculum.isEmpty ? curricula.first : selectedCurriculum;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(S.of(context).curriculumSelection,style: StylesManager.styleBold16(context).copyWith(
          color: ColorManager.mainColor15
        ),),
        const SizedBox(height: 16),
        CustomAuthDropdown(
          label: S.of(context).curriculum,
          value: selectedCurriculum,
          items: curricula,
          isRequired: true,
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedCurriculum = value);
          },
        ),
      ],
    );
  }
}