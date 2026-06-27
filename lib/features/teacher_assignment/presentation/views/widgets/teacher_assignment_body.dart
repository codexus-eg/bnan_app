import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/manager/get_teacher_assignments/get_teacher_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_dialogs.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_filter_section.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_header.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/widgets/teacher_assignment_list_bloc_builder.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentBody extends StatefulWidget {
  const TeacherAssignmentBody({super.key});

  @override
  State<TeacherAssignmentBody> createState() => _TeacherAssignmentBodyState();
}

class _TeacherAssignmentBodyState extends State<TeacherAssignmentBody> {
  TeacherAssignmentFilterType selectedFilter = TeacherAssignmentFilterType.all;

  String? get selectedStatus => selectedFilter.statusValue;

  void _onFilterChanged(TeacherAssignmentFilterType value) {
    setState(() => selectedFilter = value);
    context.read<GetTeacherAssignmentsCubit>().getAssignments(
      status: selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const TeacherAssignmentHeader(),
          TeacherAssignmentFilterSection(
            selectedFilter: selectedFilter,
            onChanged: _onFilterChanged,
          ),
          const SizedBox(height: 16),
          AddNewTopicButton(
            title: S.of(context).createNewAssignment,
            onTap: () async {
              final result =
                  await TeacherAssignmentDialogs.showCreateAssignment(context);

              if (result == true && context.mounted) {
                context.read<GetTeacherAssignmentsCubit>().getAssignments(
                  status: selectedStatus,
                );
              }
            },
          ),
          const SizedBox(height: 16),
          const Expanded(child: TeacherAssignmentListBlocBuilder()),
        ],
      ),
    );
  }
}
