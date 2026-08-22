import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/delete_assignment/delete_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/delete_assignment/delete_assignment_state.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentDismissibleCard extends StatelessWidget {
  final AssignmentModel assignment;

  const TeacherAssignmentDismissibleCard({super.key, required this.assignment});

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
      confirmDismiss: (_) => _delete(context),
      onDismissed: (_) {
        context.read<GetTeacherAssignmentsCubit>().removeAssignment(
          assignment.id,
        );
      },
      child: TeacherAssignmentCard(assignment: assignment),
    );
  }

  Future<bool> _delete(BuildContext context) async {
    if (!await _confirmDelete(context) || !context.mounted) return false;
    final cubit = DeleteAssignmentCubit.get(context);
    if (cubit.state is DeleteAssignmentLoading) return false;
    await cubit.deleteAssignment(assignmentId: assignment.id);
    if (!context.mounted) return false;
    final state = cubit.state;
    if (state is DeleteAssignmentFailure) {
      showCustomSnackBar(context, state.errorMessage, false);
      return false;
    }
    return state is DeleteAssignmentSuccess;
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
