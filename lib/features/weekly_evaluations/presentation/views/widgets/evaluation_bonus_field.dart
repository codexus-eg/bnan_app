import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EvaluationBonusField extends StatelessWidget {
  const EvaluationBonusField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: S.of(context).bonusPoints,
      controller: controller,
      keyboardType: TextInputType.number,
      backgroundColor: ColorManager.white,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        final bonus = int.tryParse(value);
        return bonus == null || bonus < 0 || bonus > 5
            ? S.of(context).invalidEvaluationBonus
            : null;
      },
    );
  }
}
