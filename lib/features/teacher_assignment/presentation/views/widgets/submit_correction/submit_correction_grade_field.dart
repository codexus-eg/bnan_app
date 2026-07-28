import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubmitCorrectionGradeField extends StatelessWidget {
  const SubmitCorrectionGradeField({
    super.key,
    required this.controller,
    required this.totalPoints,
    required this.readOnly,
  });

  final TextEditingController controller;
  final num totalPoints;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: S.of(context).degree,
      addLabel: '(0-${formatScoreNumber(totalPoints)})',
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputFormatters: [_numericInputFormatter],
      isRequired: true,
      readOnly: readOnly,
      validator: (value) => _validateScore(context, value),
    );
  }

  String? _validateScore(BuildContext context, String? value) {
    final scoreText = value?.trim() ?? '';
    if (scoreText.isEmpty) return S.of(context).scoreRequired;
    if (!RegExp(r'^-?\d+$').hasMatch(scoreText)) {
      return S.of(context).validIntegerScore;
    }
    final score = int.tryParse(scoreText);
    if (score == null) return S.of(context).validIntegerScore;
    if (score < 0 || score > totalPoints) {
      return S.of(context).scoreRange(formatScoreNumber(totalPoints));
    }
    return null;
  }
}

final _numericInputFormatter = TextInputFormatter.withFunction(
  (oldValue, newValue) =>
      RegExp(r'^-?\d*\.?\d*$').hasMatch(newValue.text) ? newValue : oldValue,
);

String formatScoreNumber(num value) {
  return value == value.truncateToDouble()
      ? value.toInt().toString()
      : value.toString();
}
