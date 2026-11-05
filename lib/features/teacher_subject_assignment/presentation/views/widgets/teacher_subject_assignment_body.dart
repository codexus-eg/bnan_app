import 'dart:async';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignments_cubit/teacher_subject_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_assignment_list.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_search_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSubjectAssignmentBody extends StatefulWidget {
  const TeacherSubjectAssignmentBody({super.key});

  @override
  State<TeacherSubjectAssignmentBody> createState() =>
      _TeacherSubjectAssignmentBodyState();
}

class _TeacherSubjectAssignmentBodyState
    extends State<TeacherSubjectAssignmentBody> {
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _teacherController.dispose();
    _subjectController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      context
          .read<TeacherSubjectAssignmentsCubit>()
          .getTeacherTeachingAssignments(
            keyword: _teacherController.text.trim(),
            subject: _subjectController.text.trim(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TeacherSubjectSearchFilters(
            teacherController: _teacherController,
            subjectController: _subjectController,
            onChanged: _onSearchChanged,
          ),
        ),
        const SizedBox(height: 16),
        const Expanded(child: TeacherSubjectAssignmentList()),
      ],
    );
  }
}
