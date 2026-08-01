import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/plans/presentation/models/term_plan_card_item.dart';
import 'package:flutter/material.dart';

class TermPlanCardDetails extends StatelessWidget {
  const TermPlanCardDetails({super.key, required this.item});

  final TermPlanCardItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 13, 9, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.classroomName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleRegular10(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
          const SizedBox(height: 4),
          Text(
            item.subjectName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StylesManager.styleBold12(
              context,
            ).copyWith(color: ColorManager.greyA8AF),
          ),
        ],
      ),
    );
  }
}
