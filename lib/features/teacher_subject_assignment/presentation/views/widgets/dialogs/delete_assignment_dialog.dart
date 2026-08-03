import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog_content.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/unassign_teacher_dialog_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAssignmentDialog extends StatelessWidget {
  const DeleteAssignmentDialog({
    super.key,
    required this.teacherId,
    required this.row,
  });

  final String teacherId;
  final AssignmentRowItem row;

  @override
  Widget build(BuildContext context) {
    final scope = UnassignTeacherDialogScope(
      teacherId: teacherId,
      classroomId: row.classroomId,
    );
    return BlocConsumer<
      TeacherSubjectAssignmentActionsCubit,
      TeacherSubjectAssignmentActionsState
    >(
      listener: (context, state) {
        if (scope.isSuccess(state)) Navigator.pop(context, true);
      },
      builder: (context, state) => DeleteAssignmentDialogContent(
        classroomName: row.classroomName,
        loading: scope.isLoading(state),
        errorMessage: scope.errorFrom(state),
        onConfirm: () => _submit(context),
      ),
    );
  }

  void _submit(BuildContext context) {
    if (teacherId.trim().isEmpty || row.classroomId.trim().isEmpty) return;
    context
        .read<TeacherSubjectAssignmentActionsCubit>()
        .unassignTeacherFromClassroom(
          teacherId: teacherId,
          classroomId: row.classroomId,
        );
  }
}
