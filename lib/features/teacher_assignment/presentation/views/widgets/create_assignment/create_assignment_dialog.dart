import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_app_dialog.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/create_assignment/create_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assigned_subjects/get_teacher_assigned_subjects_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_classrooms/get_teacher_classrooms_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_assignment_form.dart';

class CreateAssignmentDialog extends StatelessWidget {
  const CreateAssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CreateAssignmentCubit>()),
        BlocProvider(
          create: (_) => getIt<GetTeacherClassroomsCubit>()..getMyClassrooms(),
        ),
        BlocProvider(create: (_) => getIt<GetTeacherAssignedSubjectsCubit>()),
      ],
      child: const CustomAppDialog(child: CreateAssignmentForm()),
    );
  }
}
