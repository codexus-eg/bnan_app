import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/delete_assignment/delete_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentDismissibleCard extends StatelessWidget {
  final AssignmentModel assignment;

  const TeacherAssignmentDismissibleCard({
    super.key,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(assignment.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        DeleteAssignmentCubit.get(context).deleteAssignment(
          assignmentId: assignment.id,
        );
      },
      child: TeacherAssignmentCard(assignment: assignment),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(S.of(context).deleteAssignment),
              content: Text(S.of(context).deleteAssignmentConfirmation),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(S.of(context).delete),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}