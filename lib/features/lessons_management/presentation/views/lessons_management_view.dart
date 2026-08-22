import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_state.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsManagementView extends StatelessWidget {
  const LessonsManagementView({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GulfScheduleCubit>()..refresh(),
      child: Builder(
        builder: (context) =>
            BlocListener<GulfScheduleCubit, GulfScheduleState>(
              listenWhen: (previous, current) =>
                  previous.eventId != current.eventId,
              listener: _showFeedback,
              child: Scaffold(
                appBar: CustomAppbar(
                  headerText: S.of(context).lessonsManagement,
                  iconNeeded: showBackButton,
                ),
                body: const LessonsManagementBody(),
              ),
            ),
      ),
    );
  }

  void _showFeedback(BuildContext context, GulfScheduleState state) {
    final s = S.of(context);
    final success = state.actionSuccess;
    final message =
        state.actionError ??
        switch (state.actionIssue) {
          GulfScheduleIssue.missingClassroomSubject =>
            s.gulfClassroomSubjectUnavailable,
          GulfScheduleIssue.duplicateDay => s.duplicateScheduleDay,
          GulfScheduleIssue.invalidData => s.fillAllRequiredFields,
          null => switch (success) {
            GulfScheduleAction.added => s.gulfScheduleEntryAdded,
            GulfScheduleAction.updated => s.gulfScheduleEntryUpdated,
            GulfScheduleAction.deleted => s.gulfScheduleEntryDeleted,
            null => s.unexpectedError,
          },
        };
    showCustomSnackBar(context, message, success != null);
  }
}
