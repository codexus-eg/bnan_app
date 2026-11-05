import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_assigned_subject.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_cubit.dart';
import 'package:bnan_app/features/classrooms_management/presentation/manager/classroom_subjects_cubit/classroom_subjects_state.dart';
import 'package:bnan_app/features/classrooms_management/presentation/views/widgets/dialogs/delete_classroom_subject_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassroomSubjectsDialogStateView extends StatelessWidget {
  const ClassroomSubjectsDialogStateView({
    super.key,
    required this.state,
    required this.header,
    required this.body,
  });

  final ClassroomSubjectsState state;
  final Widget header;
  final Widget Function(ClassroomSubjectsLoaded?) body;

  @override
  Widget build(BuildContext context) {
    if (state is ClassroomSubjectsLoading) {
      return const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()));
    }
    if (state is ClassroomSubjectsFailure) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text((state as ClassroomSubjectsFailure).message, style: const TextStyle(color: ColorManager.red))),
      );
    }
    final loaded = state is ClassroomSubjectsLoaded ? state as ClassroomSubjectsLoaded : null;
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [header, const SizedBox(height: 16), body(loaded)]),
    );
  }
}

Future<void> deleteClassroomSubjectAction(BuildContext context, String classroomId, ClassroomAssignedSubject sub) async {
  final ok = await showDialog<bool>(context: context, builder: (_) => DeleteClassroomSubjectDialog(subjectName: sub.name));
  if (ok == true && context.mounted) {
    context.read<ClassroomSubjectsCubit>().deleteSubject(classroomId: classroomId, classroomSubjectId: sub.effectiveClassroomSubjectId);
  }
}
