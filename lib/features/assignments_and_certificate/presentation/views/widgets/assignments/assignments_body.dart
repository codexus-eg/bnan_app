import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignment_model.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignment_status.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignments_filter_type.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignment_card.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignments_filter_tabs.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssignmentsBody extends StatefulWidget {
  const AssignmentsBody({super.key});

  @override
  State<AssignmentsBody> createState() => _AssignmentsBodyState();
}

class _AssignmentsBodyState extends State<AssignmentsBody> {
  AssignmentsFilterType selectedFilter = AssignmentsFilterType.all;

  @override
  Widget build(BuildContext context) {
    final assignments = _assignments(context);
    final filteredAssignments = _filteredAssignments(assignments);

    return Column(
      children: [
        CustomAppbar(headerText: S.of(context).assignments,iconNeeded: false,),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: AssignmentsFilterTabs(
                    selectedFilter: selectedFilter,
                    onChanged: (value) {
                      setState(() => selectedFilter = value);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredAssignments.length,
                    itemBuilder: (_, index) {
                      return AssignmentCard(
                        assignment: filteredAssignments[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<AssignmentModel> _filteredAssignments(List<AssignmentModel> items) {
    if (selectedFilter == AssignmentsFilterType.all) return items;

    return items.where((item) {
      if (selectedFilter == AssignmentsFilterType.pending) {
        return item.status == AssignmentStatus.pending;
      }

      return item.status == AssignmentStatus.completed;
    }).toList();
  }

  List<AssignmentModel> _assignments(BuildContext context) {
    return [
      AssignmentModel(
        subject: S.of(context).math,
        title: S.of(context).thirdTermExercises,
        dueDate: S.of(context).dueFriday,
        badgeText: S.of(context).newBadge,
        status: AssignmentStatus.pending,
        canSubmit: true,
      ),
      AssignmentModel(
        subject: S.of(context).science,
        title: S.of(context).lightAndShadowExperiment,
        dueDate: S.of(context).dueSunday,
        badgeText: S.of(context).submittedBadge,
        status: AssignmentStatus.pending,
        canSubmit: false,
      ),
      AssignmentModel(
        subject: S.of(context).arabicLanguage,
        title: S.of(context).poemAnalysis,
        dueDate: S.of(context).noSubmission,
        badgeText: '9/10',
        status: AssignmentStatus.completed,
        canSubmit: false,
      ),
    ];
  }
}
