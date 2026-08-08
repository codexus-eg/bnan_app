import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';

class PayrollSection extends StatelessWidget {
  const PayrollSection({super.key, required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: StylesManager.styleBold16(
            context,
          ).copyWith(color: Colors.black),
        ),
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}
