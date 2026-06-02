import 'package:bnan_app/features/assignments_and_certificate/data/assignment_model.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignment_status.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/shared_widgets/material_header.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignment_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentsPreviewSection extends StatelessWidget {
  const AssignmentsPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final assignments = [
      AssignmentModel(
        subject: S.of(context).math,
        title: S.of(context).thirdTermExercises,
        dueDate: S.of(context).dueFriday,
        badgeText: S.of(context).newBadge,
        status: AssignmentStatus.pending,
        canSubmit: true
      ),
      AssignmentModel(
        subject: S.of(context).math,
        title: S.of(context).thirdTermExercises,
        dueDate: S.of(context).dueSunday,
        badgeText: S.of(context).submittedBadge,
        status: AssignmentStatus.completed,
        canSubmit: false
      ),
    ];

    return Container(
      margin:EdgeInsetsDirectional.symmetric(vertical: 16,horizontal: 16) ,
      padding: const EdgeInsetsDirectional.symmetric(vertical: 8),
      child: Column(
        children: [
       MaterialsHeader(onViewAllTap: (){}, header: S.of(context).assignments),
          ...List.generate(assignments.length, (index) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == assignments.length - 1 ? 0 : 8,
              ),
              child: AssignmentCard(assignment: assignments[index]),
            );
          }),
        ],
      ),
    );
  }
}
