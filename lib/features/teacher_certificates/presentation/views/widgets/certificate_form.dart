import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_certificates/presentation/views/widgets/certificate_subject_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class CertificateForm extends StatelessWidget {
  const CertificateForm({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final subjects = const ['لغة عربية', 'رياضيات', 'English', 'علوم'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDialogHeader(title: title),
        const SizedBox(height: 16),
        CustomDropdown(
          hint: 'شهد أحمد',
          isRequired: true,
          items: ['شهد أحمد'],
          label: S.of(context).student,
          hintStyle: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          backgroundColor: ColorManager.white,
          onChanged: (String? value) {},
        ),
        const SizedBox(height: 16),
        CustomDropdown(
          hint: 'اختر الصف',
          isRequired: true,
          items: ['الصف الثالث'],
          label: S.of(context).grade,
          hintStyle: StylesManager.styleRegular16(
            context,
          ).copyWith(color: ColorManager.mainColor14),
          onChanged: (String? value) {},
        ),
        const SizedBox(height: 16),
        Text(
          S.of(context).subjectsGrades,
          style: StylesManager.styleBold14(
            context,
          ).copyWith(color: ColorManager.mainColor14),
        ),
        const SizedBox(height: 8),
        ...subjects.map((subject) => CertificateSubjectRow(subject: subject)),
        const SizedBox(height: 16),
        CustomAppButton(text: S.of(context).save, onPressed: () {}),
      ],
    );
  }
}
