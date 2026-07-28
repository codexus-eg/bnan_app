import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'correction_summary_item.dart';

class CorrectionSummary extends StatelessWidget {
  const CorrectionSummary({
    super.key,
    required this.totalStudents,
    required this.reviewed,
    required this.submitted,
    required this.notSubmitted,
  });

  final int totalStudents;
  final int reviewed;
  final int submitted;
  final int notSubmitted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _item(
              width: itemWidth,
              count: totalStudents,
              title: S.of(context).totalStudents,
              image: ImageManager.userProfileGroupIcon,
            ),
            _item(
              width: itemWidth,
              count: reviewed,
              title: S.of(context).graded,
              image: ImageManager.teacherAssignmentCheckContainedIcon,
            ),
            _item(
              width: itemWidth,
              count: submitted,
              title: S.of(context).submitted,
              image: ImageManager.teacherAssignmentClockIcon,
            ),
            _item(
              width: itemWidth,
              count: notSubmitted,
              title: S.of(context).notSubmitted,
              image: ImageManager.teacherAssignmentCircleWarningIcon,
            ),
          ],
        );
      },
    );
  }

  Widget _item({
    required double width,
    required int count,
    required String title,
    required String image,
  }) {
    return SizedBox(
      width: width,
      child: CorrectionSummaryItem(count: count, title: title, image: image),
    );
  }
}
