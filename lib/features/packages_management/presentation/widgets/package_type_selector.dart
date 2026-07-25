import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class PackageTypeSelector extends StatelessWidget {
  const PackageTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              S.of(context).packageType,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),

            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildOption(
                context,
                'monthly',
                S.of(context).monthlyPackage,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildOption(
                context,
                'hours',
                S.of(context).packageHoursType,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildOption(BuildContext context, String type, String title) {
    final isSelected = value == type;

    return InkWell(
      onTap: () => onChanged(type),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.borderColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectionCircle(isSelected: isSelected),
            const SizedBox(width: 16),
            Text(
              title,
              style: StylesManager.styleBold12(
                context,
              ).copyWith(color: ColorManager.black),
            ),
          ],
        ),
      ),
    );
  }
}
