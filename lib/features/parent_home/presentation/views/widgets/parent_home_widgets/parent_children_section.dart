import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_children_preview_cards.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentChildrenSection extends StatelessWidget {
  const ParentChildrenSection({super.key, required this.onShowAll});

  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      children: [
        Row(
          children: [
            Text(
              s.parentYourChildren,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.black),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onShowAll,
              behavior: HitTestBehavior.opaque,
              child: Text(
                s.parentShowAll,
                style: StylesManager.styleBold12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const ParentChildrenPreviewCards(),
      ],
    );
  }
}
