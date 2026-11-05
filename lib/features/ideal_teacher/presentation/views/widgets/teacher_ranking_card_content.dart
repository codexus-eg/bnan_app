import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/add_point_adjustment_dialog.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_avatar.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_meta.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/point_adjustment_history_dialog.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_ranking_components_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherRankingCardContent extends StatefulWidget {
  const TeacherRankingCardContent({
    super.key,
    required this.teacher,
    required this.selected,
    required this.canModify,
    required this.canSelect,
  });

  final TeacherRankingItemModel teacher;
  final bool selected, canModify, canSelect;

  @override
  State<TeacherRankingCardContent> createState() =>
      _TeacherRankingCardContentState();
}

class _TeacherRankingCardContentState extends State<TeacherRankingCardContent> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final teacher = widget.teacher;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: ColorManager.blueE3,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '${teacher.rank}',
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
            const SizedBox(width: 8),
            IdealTeacherAvatar(name: teacher.fullName, url: teacher.avatar),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher.fullName,
                    style: StylesManager.styleBold14(context),
                  ),
                  if (teacher.weeklyPoints != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${s.weeklyScoreOutOf100}: ${teacher.weeklyPoints} / 100',
                      style: StylesManager.styleBold12(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                  ],
                  if (teacher.components.interaction.available) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${s.interactionPoints}: ${teacher.manualPoints} / ${teacher.components.interaction.max > 0 ? teacher.components.interaction.max : 10}',
                      style: StylesManager.styleRegular12(
                        context,
                      ).copyWith(color: ColorManager.grey7A7C),
                    ),
                  ],
                  const SizedBox(height: 2),
                  IdealTeacherMeta(label: s.subject, values: teacher.subjects),
                ],
              ),
            ),
            if (widget.canSelect)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SelectionCircle(isSelected: widget.selected),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? '— ${s.evaluationComponents}' : '+ ${s.evaluationComponents}',
                style: StylesManager.styleBold12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
            if (widget.canModify)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => PointAdjustmentHistoryDialog.show(
                      context,
                      teacherId: teacher.teacherId,
                      teacherName: teacher.fullName,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text(
                        s.viewHistory,
                        style: StylesManager.styleBold12(
                          context,
                        ).copyWith(color: ColorManager.mainColor14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => AddPointAdjustmentDialog.show(
                      context,
                      teacherId: teacher.teacherId,
                      teacherName: teacher.fullName,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.mainColor14,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        s.addPoints,
                        style: StylesManager.styleBold12(
                          context,
                        ).copyWith(color: ColorManager.white),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        if (_expanded) ...[
          const SizedBox(height: 8),
          TeacherRankingComponentsView(components: teacher.components),
        ],
      ],
    );
  }
}
