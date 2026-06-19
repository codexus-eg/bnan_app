import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/assignment_colors.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/assignment_texts.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/assignments_footer.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/teacher_assignment_dialogs.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/teacher_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({super.key, required this.assignment});
  final TeacherAssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    final colors = AssignmentColors.fromStatus(assignment.status);
    return InkWell(
      onTap: ()=>TeacherAssignmentDialogs.showCorrectAssignment(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsetsDirectional.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * .25).round()),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentTexts(assignment: assignment),
                const Spacer(),
                TeacherStatusBadge(
                  title: _getStatusTitle(context, assignment.status),
                  color: colors.badgeColor,
                  textColor: colors.textColor,
                ),
              ],
            ),
            const SizedBox(height: 7),
            AssignmentFooter(assignment: assignment),
          ],
        ),
      ),
    );
  }

  String _getStatusTitle(BuildContext context, TeacherAssignmentStatus status) {
    switch (status) {
      case TeacherAssignmentStatus.active:
        return S.of(context).active2;
      case TeacherAssignmentStatus.submitted:
        return S.of(context).submitted;
      case TeacherAssignmentStatus.notSubmitted:
        return S.of(context).notSubmitted;
      case TeacherAssignmentStatus.finished:
        return S.of(context).finished;
    }
  }
}
