import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SummaryNextSteps extends StatelessWidget {
  const SummaryNextSteps({super.key, required this.steps});
  final List<String> steps;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).nextSteps,
          style: StylesManager.styleBold18(context),
        ),
        const SizedBox(height: 12),
        ...steps.map(
          (step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                  color: ColorManager.mainColor14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step,
                    style: StylesManager.styleRegular14(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
