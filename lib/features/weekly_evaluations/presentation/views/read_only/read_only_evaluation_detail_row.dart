import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class ReadOnlyEvaluationDetailRow extends StatelessWidget {
  const ReadOnlyEvaluationDetailRow({
    super.key,
    required this.label,
    required this.value,
  });
  final String label, value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: StylesManager.styleBold12(context))),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: StylesManager.styleRegular12(
              context,
            ).copyWith(color: ColorManager.mainColor15),
          ),
        ),
      ],
    ),
  );
}
