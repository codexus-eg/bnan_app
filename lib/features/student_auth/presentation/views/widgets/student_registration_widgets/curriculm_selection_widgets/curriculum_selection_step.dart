import 'package:bnan_app/core/app_routes/routes_export.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CurriculumSelectionStep extends StatelessWidget {
  const CurriculumSelectionStep({super.key});

  @override
  Widget build(BuildContext context) {
   final registerCubit =RegisterCubit.get(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(S.of(context).curriculumSelection,style: StylesManager.styleBold16(context).copyWith(
        //   color: ColorManager.mainColor15
        // ),),
        // const SizedBox(height: 16),
        CustomDropdown(
          label: S.of(context).curriculum,
         value: registerCubit.curriculumName,
          items: [registerCubit.curriculumName],
          isRequired: true,
          onChanged: (value) {
            // if (value == null) return;
            // setState(() => selectedCurriculum = value);
          },
        ),
      ],
    );
  }
}