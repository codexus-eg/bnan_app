import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/supervisor_teacher_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_avatar.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_meta.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class IdealTeacherCardContent extends StatelessWidget {
  const IdealTeacherCardContent({
    super.key,
    required this.teacher,
    required this.selected,
    this.canSelect = true,
  });
  final SupervisorTeacherModel teacher;
  final bool selected;
  final bool canSelect;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      IdealTeacherAvatar(name: teacher.name, url: teacher.avatar),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teacher.name, style: StylesManager.styleBold14(context)),
            IdealTeacherMeta(
              label: S.of(context).subjects,
              values: teacher.subjects,
            ),
            IdealTeacherMeta(
              label: S.of(context).classrooms,
              values: teacher.classrooms,
            ),
          ],
        ),
      ),
      if (canSelect) ...[
        const SizedBox(width: 8),
        SelectionCircle(isSelected: selected),
      ],
    ],
  );
}
