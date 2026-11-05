import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_model.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subjects_dialog_body.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/classroom_subjects_dialog_state_view.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomSubjectsDialog extends StatefulWidget {
  const ClassroomSubjectsDialog({super.key, required this.classroomItem});
  final ClassroomModel classroomItem;

  @override
  State<ClassroomSubjectsDialog> createState() => _ClassroomSubjectsDialogState();
}

class _ClassroomSubjectsDialogState extends State<ClassroomSubjectsDialog> {
  String? selectedSubjectId;

  @override
  Widget build(BuildContext context) {
    return CustomAppDialog(
      child: BlocBuilder<ClassroomSubjectsCubit, ClassroomSubjectsState>(
        builder: (context, state) => ClassroomSubjectsDialogStateView(
          state: state,
          header: CustomDialogHeader(
            title: '${S.of(context).classroomSubjects}: ${widget.classroomItem.name}',
          ),
          body: (loaded) => ClassroomSubjectsDialogBody(
            loaded: loaded,
            selectedSubjectId: selectedSubjectId,
            onSubjectChanged: (id) => setState(() => selectedSubjectId = id),
            onAdd: () {
              context.read<ClassroomSubjectsCubit>().addSubject(classroomId: widget.classroomItem.id, subjectId: selectedSubjectId!);
              setState(() => selectedSubjectId = null);
            },
            onDelete: (sub) => deleteClassroomSubjectAction(context, widget.classroomItem.id, sub),
          ),
        ),
      ),
    );
  }
}
