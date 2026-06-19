import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/filter_chip/custom_filter_tabs.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/assignments_filter_type.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/assignment_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/assignment_status.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_assignment/get_assignments_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/get_assignment/get_assignments_state.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/manager/submit_assignment/submit_assignment_cubit.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_card.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignments_empty_state.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentsBody extends StatefulWidget {
  const AssignmentsBody({super.key});

  @override
  State<AssignmentsBody> createState() => _AssignmentsBodyState();
}

class _AssignmentsBodyState extends State<AssignmentsBody> {
  AssignmentsFilterType selectedFilter = AssignmentsFilterType.all;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<GetAssignmentsCubit>()..getMyAssignments(),
        ),
        BlocProvider(create: (_) => getIt<SubmitAssignmentCubit>()),
      ],
      child: Column(
        children: [
          CustomAppbar(
            headerText: S.of(context).assignments,
            iconNeeded: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: BlocBuilder<GetAssignmentsCubit, GetAssignmentsState>(
                builder: (context, state) {
                  final isLoading = state is GetAssignmentsLoading;

                  if (state is GetAssignmentsFailure) {
                    return Center(child: Text(state.errorMessage));
                  }

                  final assignments = state is GetAssignmentsSuccess
                      ? state.assignments
                      : AssignmentModel.placeholderList();

                  final filteredAssignments = _filteredAssignments(assignments);

                  return AppSkeletonizer(
                    isLoading: isLoading,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        CustomFilterTabs<AssignmentsFilterType>(
                          items: {
                            AssignmentsFilterType.all: S.of(context).all,
                            AssignmentsFilterType.pending: S
                                .of(context)
                                .pending,
                            AssignmentsFilterType.completed: S
                                .of(context)
                                .completed,
                          },
                          selectedItem: selectedFilter,
                          onChanged: (value) {
                            setState(() => selectedFilter = value);
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: filteredAssignments.isEmpty && !isLoading
                              ? AssignmentsEmptyState(
                                  selectedFilter: selectedFilter,
                                )
                              : ListView.builder(
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
}
