import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';


class SubmitCorrectionGradeField extends StatelessWidget {
  const SubmitCorrectionGradeField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: S.of(context).degree,
      addLabel:'(10-0)',
      controller: controller,
      keyboardType: TextInputType.number,
    );
  }
}