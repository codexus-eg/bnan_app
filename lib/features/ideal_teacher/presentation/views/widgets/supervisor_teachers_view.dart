import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/ideal_teacher_skeleton_data.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/confirm_issue_ideal_teacher_dialog.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/ideal_teacher_failure.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/supervisor_teachers_list.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/views/widgets/teacher_search_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorTeachersView extends StatelessWidget {
  const SupervisorTeachersView({
    super.key,
    required this.state,
    required this.searchController,
    this.scrollController,
  });

  final SupervisorIdealTeacherState state;
  final TextEditingController searchController;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorIdealTeacherCubit>();
    final role = SessionManager.instance.role;
    final canSelect = IdealTeacherAccessPolicy.canSelectTeachers(role);
    final canIssue = IdealTeacherAccessPolicy.canIssueCertificate(role);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: TeacherSearchField(
            controller: searchController,
            onChanged: cubit.setSearchQuery,
            onClear: () {
              searchController.clear();
              cubit.setSearchQuery('');
            },
          ),
        ),
        Expanded(child: _content(context, cubit, canSelect)),
        if (canIssue)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 16),
            child: CustomAppButton(
              text: S.of(context).issueCertificate,
              isLoading: state.isSubmitting,
              onPressed: state.selectedTeacherIds.isNotEmpty &&
                      !state.isSubmitting
                  ? () => _confirmAndSubmit(context)
                  : null,
            ),
          ),
      ],
    );
  }

  Widget _content(
    BuildContext context,
    SupervisorIdealTeacherCubit cubit,
    bool canSelect,
  ) {
    if (state.isLoading) {
      return const AppSkeletonizer(
        isLoading: true,
        child: SupervisorTeachersList(
          teachers: supervisorTeachersSkeleton,
          selectedIds: {},
          canSelect: false,
          onToggle: null,
        ),
      );
    }
    if (state.status == SupervisorIdealTeacherStatus.failure &&
        state.teachers.isEmpty) {
      return IdealTeacherFailure(
        message: state.message,
        onRetry: cubit.loadTeachers,
      );
    }
    if (state.filteredTeachers.isEmpty) {
      return NoDataWidget(title: S.of(context).noTeachersAvailable);
    }
    return RefreshIndicator(
      onRefresh: cubit.loadTeachers,
      child: SupervisorTeachersList(
        teachers: state.filteredTeachers,
        selectedIds: state.selectedTeacherIds,
        canSelect: canSelect,
        onToggle: canSelect && !state.isSubmitting ? cubit.toggleTeacher : null,
        scrollController: scrollController,
      ),
    );
  }

  Future<void> _confirmAndSubmit(BuildContext context) async {
    final signer = await ConfirmIssueIdealTeacherDialog.show(context);
    if (signer != null && signer.isNotEmpty && context.mounted) {
      context.read<SupervisorIdealTeacherCubit>().submitIdealTeachers(
        signerName: signer,
      );
    }
  }
}
