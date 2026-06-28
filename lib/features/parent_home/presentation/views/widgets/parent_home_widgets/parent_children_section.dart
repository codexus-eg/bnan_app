import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/data/models/parent_child_model.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_children/parent_child_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ParentChildrenSection extends StatelessWidget {
  const ParentChildrenSection({super.key});

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
              onTap: () {},
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
        ParentChildCard(parentChildModel: children[0]),
        const SizedBox(height: 8),
        ParentChildCard(parentChildModel: children[1]),
      ],
    );
  }
}
