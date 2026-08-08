import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PayrollWarningCard extends StatelessWidget {
  const PayrollWarningCard({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    backgroundColor: ColorManager.orangeFFE,
    shadow: false,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.warning_amber_rounded, color: ColorManager.orangeED),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: StylesManager.styleRegular14(
              context,
            ).copyWith(color: ColorManager.orangeED),
          ),
        ),
      ],
    ),
  );
}
