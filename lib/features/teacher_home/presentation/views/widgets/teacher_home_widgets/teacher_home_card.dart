import 'package:bnan_app/core/shared_widget/home_card_widget.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_card_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherHomeCard extends StatelessWidget {
  const TeacherHomeCard({super.key, required this.points});
  final int points;

  @override
  Widget build(BuildContext context) => HomeCardWidget(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TeacherHomeCardHeader(),
        const SizedBox(height: 30),
        Row(
          children: [
            Text(
              '$points ',
              style: StylesManager.styleBold16(
                context,
              ).copyWith(color: ColorManager.white),
            ),
            Text(
              S.of(context).pointsCount,
              style: StylesManager.styleRegular16(
                context,
              ).copyWith(color: ColorManager.white),
            ),
          ],
        ),
        const SizedBox(height: 18),
      ],
    ),
  );
}
