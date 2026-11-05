import 'package:bnan_app/core/shared_widget/progress_line.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class SubscriptionProgressBar extends StatelessWidget {
  const SubscriptionProgressBar({
    super.key,
    required this.usedHours,
    required this.totalHours,
    this.showHours = false,
  });

  final num usedHours, totalHours;
  final bool showHours;

  @override
  Widget build(BuildContext context) {
    final total = totalHours.toDouble(), used = usedHours.toDouble();
    final progress = total > 0 ? (used / total).clamp(0.0, 1.0) : 0.0;
    final pct = progress * 100;
    final formatted = pct == pct.roundToDouble()
        ? '${pct.toInt()}%'
        : '${pct.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '')}%';
    final label = showHours
        ? '$formatted (${_n(usedHours)} / ${_n(totalHours)})'
        : formatted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).progress,
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: ColorManager.grey7A7C),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Text(
                label,
                style: StylesManager.styleBold12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ProgressLine(value: progress, color: ColorManager.blue007),
      ],
    );
  }

  String _n(num v) => v is int || v == v.roundToDouble()
      ? v.toInt().toString()
      : v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
}
