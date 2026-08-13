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
    this.monthlyEnabled = true,
    this.showMonthly = true,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final bool monthlyEnabled;
  final bool showMonthly;

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
        if (showMonthly)
          Row(
            children: [
              Expanded(
                child: buildOption(
                  context,
                  'monthly',
                  S.of(context).monthlyPackage,
                  enabled: monthlyEnabled,
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
          )
        else
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: buildOption(
              context,
              'hours',
              S.of(context).packageHoursType,
            ),
          ),
      ],
    );
  }

  Widget buildOption(
    BuildContext context,
    String type,
    String title, {
    bool enabled = true,
  }) {
    final isSelected = value == type;

    return Opacity(
      opacity: enabled ? 1 : .45,
      child: InkWell(
        onTap: enabled ? () => onChanged(type) : null,
        child: Container(
          height: 44,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: ColorManager.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}
