import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/assignment_colors.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/assignment_texts.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/assignments_footer.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_dialogs.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_status_badge.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({super.key, required this.assignment});
  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    final colors = AssignmentColors.fromStatus(assignment.status);
    return InkWell(
      onTap: () => TeacherAssignmentDialogs.showCorrectAssignment(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsetsDirectional.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * .25).round()),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: AssignmentTexts(assignment: assignment)),
                const SizedBox(width: 8),
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

  String _getStatusTitle(BuildContext context, String status) {
    if (status == 'active') return S.of(context).active2;
    return S.of(context).finished;
  }
}
