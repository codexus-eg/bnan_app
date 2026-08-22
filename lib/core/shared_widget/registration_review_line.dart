import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class RegistrationReviewLine extends StatelessWidget {
  const RegistrationReviewLine({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text('$label: $value', style: StylesManager.styleRegular14(context)),
  );
}
