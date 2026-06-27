import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/delete_assignment/delete_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/update_assignment/update_assignment_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentsView extends StatelessWidget {
  const TeacherAssignmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetTeacherAssignmentsCubit>()..getAssignments(),
        ),
       
        BlocProvider(
          create: (_) => getIt<UpdateAssignmentCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<DeleteAssignmentCubit>(),
        ),
        
      ],
      child: const TeacherAssignmentBody(),
    );
  }
}