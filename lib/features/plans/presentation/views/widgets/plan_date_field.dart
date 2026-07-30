import 'package:bnan_app/core/helper/app_pickers.dart';
import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlanDateField extends StatelessWidget {
  const PlanDateField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomTextField(
      label: s.day,
      hintText: s.dateFormatHint,
      controller: controller,
      isRequired: true,
      readOnly: true,
      validator: (value) => MyValidator.requiredField(value, s.day),
      onTap: () => _pickDate(context),
      suffixIcon: Padding(
        padding: const EdgeInsetsDirectional.only(end: 10),
        child: SvgPicture.asset(
          ImageManager.teacherAssignmentDateIcon,
          width: 16,
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await AppPickers.pickDate(context: context);
    if (date != null && context.mounted) {
      controller.text = MaterialLocalizations.of(context).formatShortDate(date);
    }
  }
}
