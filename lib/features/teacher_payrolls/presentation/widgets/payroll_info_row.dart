import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PayrollInfoRow extends StatelessWidget {
  const PayrollInfoRow({super.key, required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: StylesManager.styleRegular14(context)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            textAlign: TextAlign.end,
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ),
      ],
    ),
  );
}
