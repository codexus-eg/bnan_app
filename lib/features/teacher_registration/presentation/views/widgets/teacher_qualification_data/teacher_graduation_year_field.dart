import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/schedule_picker_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_registration/presentation/manager/teacher_registration_cubit/teacher_registration_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherGraduationYearField extends StatelessWidget {
  const TeacherGraduationYearField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = TeacherRegistrationCubit.get(context);

    return FormField<String>(
      initialValue: cubit.graduationYearController.text,
      validator: (value) =>
          MyValidator.requiredField(value, S.of(context).graduationYear),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SchedulePickerField(
              label: S.of(context).graduationYear,
              value: cubit.graduationYearController.text.isEmpty
                  ? null
                  : cubit.graduationYearController.text,
              icon: ImageManager.calendarIcon,
              onTap: () async {
                final year = await AppPickers.pickYear(
                  context: context,
                  title: S.of(context).graduationYear,
                  selectedYear: cubit.selectedGraduationYear,
                );
                if (year != null) {
                  cubit.changeGraduationYear(year);
                  field.didChange(year.toString());
                }
              },
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Text(
                field.errorText ?? '',
                style: StylesManager.styleRegular12(context).copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}