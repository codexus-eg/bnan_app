import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/teacher_assignment/data/model/assignment_model.dart';
import 'package:bnan_app/features/teacher_assignment/data/teacher_assignment_filter_type.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/add_new_assignment_button.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/widgets/teacher_assignment_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherAssignmentBody extends StatefulWidget {
  const TeacherAssignmentBody({super.key});

  @override
  State<TeacherAssignmentBody> createState() => _TeacherAssignmentBodyState();
}

class _TeacherAssignmentBodyState extends State<TeacherAssignmentBody> {
  TeacherAssignmentFilterType selectedFilter = TeacherAssignmentFilterType.all;

  List<TeacherAssignmentModel> get filteredAssignments {
    if (selectedFilter == TeacherAssignmentFilterType.all) {
      return assignments;
    }

    return assignments.where((assignment) {
      return assignment.status.name == selectedFilter.name;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppbar(headerText: S.of(context).assignments,iconNeeded: false,),
          CustomFilterTabs<TeacherAssignmentFilterType>(
            items: {
              TeacherAssignmentFilterType.all: S.of(context).all,
              TeacherAssignmentFilterType.active: S.of(context).active2,
              TeacherAssignmentFilterType.submitted: S.of(context).submitted,
              TeacherAssignmentFilterType.notSubmitted: S
                  .of(context)
                  .notSubmitted,
              TeacherAssignmentFilterType.finished: S.of(context).finished,
            },
            selectedItem: selectedFilter,
            onChanged: (value) {
              setState(() => selectedFilter = value);
            },
          ),
          const SizedBox(height: 16),
          const AddNewAssignmentButton(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: filteredAssignments.length,
              itemBuilder: (context, index) {
                return TeacherAssignmentCard(
                  assignment: filteredAssignments[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
