import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_home_widgets/parent_child_card.dart';
import 'package:flutter/material.dart';

class ParentChildrenSection extends StatelessWidget {
  const ParentChildrenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'أبناؤك',
              style: StylesManager.styleBold14(context).copyWith(
                color: ColorManager.black,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Text(
                'عرض الكل',
                style: StylesManager.styleBold12(context).copyWith(
                  color: ColorManager.mainColor14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const ParentChildCard(
          name: 'ليلى خالد',
          grade: 'الصف الأول الإعدادي',
        ),
        const SizedBox(height: 8),
        const ParentChildCard(
          name: 'أحمد خالد',
          grade: 'الصف الثاني الإعدادي',
        ),
      ],
    );
  }
}
