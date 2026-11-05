import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeacherRankingHeader extends StatelessWidget {
  const TeacherRankingHeader({
    super.key,
    required this.classrooms,
    required this.selectedClassroom,
    required this.onClassroomChanged,
    this.response,
  });

  final List<PlanClassroomOption> classrooms;
  final PlanClassroomOption? selectedClassroom;
  final ValueChanged<PlanClassroomOption?> onClassroomChanged;
  final TeacherRankingResponse? response;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final period = response?.period;
    final periodText = (period?.weekStart != null && period?.weekEnd != null)
        ? '${period!.weekStart!.day}/${period.weekStart!.month} - ${period.weekEnd!.day}/${period.weekEnd!.month}'
        : '';

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDropdown(
            label: s.classRoom,
            items: classrooms.map((c) => c.id).toList(),
            itemsLabels: {for (final c in classrooms) c.id: c.name},
            value: selectedClassroom?.id,
            onChanged: (id) => onClassroomChanged(
              classrooms.where((c) => c.id == id).firstOrNull,
            ),
          ),
          if (response != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (periodText.isNotEmpty)
                  Text(
                    periodText,
                    style: StylesManager.styleRegular12(context).copyWith(
                      color: ColorManager.grey7A7C,
                    ),
                  ),
                if (response!.isProvisional)
                  StatusBadge(text: s.provisional),
              ],
            ),
          ],
          if (response?.hasQualifiedWinner == true) ...[
            const SizedBox(height: 8),
            _WinnerBanner(name: response!.idealTeacher!.fullName),
          ],
        ],
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => CustomDetailsWidgetBackground(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    backgroundColor: ColorManager.blueE3,
    child: Row(
      children: [
        SvgPicture.asset(
          ImageManager.crownSimple,
          width: 22,
          height: 22,
          colorFilter: const ColorFilter.mode(
            ColorManager.mainColor14,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '${S.of(context).idealTeacher}: $name',
            style: StylesManager.styleBold14(
              context,
            ).copyWith(color: ColorManager.mainColor14),
          ),
        ),
      ],
    ),
  );
}
