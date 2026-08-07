import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/student_subjects/presentation/manager/get_student_subjects/get_student_subjects_cubit.dart';
import 'package:bnan_app/features/student_subjects/presentation/views/widgets/student_subjects_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentSubjectsView extends StatelessWidget {
  const StudentSubjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetMySubjectsCubit>()..loadSubjects(),
      child: const Scaffold(
        body: SafeArea(child: StudentSubjectsBody()),
      ),
    );
  }
}
