import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/teacher_subject_assignment/data/models/assignment_row_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignment_actions_cubit/teacher_subject_assignment_actions_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/manager/teacher_subject_assignments_cubit/teacher_subject_assignments_cubit.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/assign_subject_dialog.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/dialogs/delete_assignment_dialog.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_subject_assignment_card_item.dart';
import 'package:bnan_app/features/teacher_subject_assignment/presentation/views/widgets/teacher_assignment_details_row.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherAssignmentCard extends StatelessWidget {
  const TeacherAssignmentCard({super.key, required this.item});
  final TeacherSubjectAssignmentCardItem item;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.teacherName,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold16(
                    context,
                  ).copyWith(color: ColorManager.mainColor14),
                ),
              ),
              const SizedBox(width: 12),
              AddNewTopicButton(
                title: S.of(context).assignSubject,
                path: ImageManager.plus,
                onTap: () => _showAssignSubjectDialog(context),
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 22,
                  vertical: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...item.rows.map(
            (row) => TeacherAssignmentDetailsRow(
              row: row,
              onTap: () => _showDeleteAssignmentDialog(context, row),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteAssignmentDialog(
    BuildContext context,
    AssignmentRowItem row,
  ) async {
    if (item.teacherId.trim().isEmpty || row.classroomId.trim().isEmpty) return;
    final actionsCubit = context.read<TeacherSubjectAssignmentActionsCubit>();
    final assignmentsCubit = context.read<TeacherSubjectAssignmentsCubit>();
    final removed = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: actionsCubit,
        child: DeleteAssignmentDialog(teacherId: item.teacherId, row: row),
      ),
    );
    if (removed != true) return;
    await assignmentsCubit.getTeacherTeachingAssignments();
    if (getIt.isRegistered<ChatNotificationCoordinator>()) {
      getIt<ChatNotificationCoordinator>().handleRoomCreated({});
    }
    if (!context.mounted) return;
    showCustomSnackBar(
      context,
      S.of(context).teacherUnassignedSuccessfully,
      true,
    );
  }

  Future<void> _showAssignSubjectDialog(BuildContext context) async {
    final actionsCubit = context.read<TeacherSubjectAssignmentActionsCubit>();
    final assignmentsCubit = context.read<TeacherSubjectAssignmentsCubit>();

    final result = await showDialog<String>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: actionsCubit),
          BlocProvider(
            create: (_) => AcademicLookupsCubit(
              repo: getIt<AcademicLookupsRepo>(),
              loadClassroomsOnGrade: true,
              loadSubjectsWithoutClassroom: false,
            ),
          ),
        ],
        child: AssignSubjectDialog(
          teacherId: item.teacherId,
          teacherName: item.teacherName,
        ),
      ),
    );

    if (result != null) {
      await assignmentsCubit.getTeacherTeachingAssignments();
      if (getIt.isRegistered<ChatNotificationCoordinator>()) {
        getIt<ChatNotificationCoordinator>().handleRoomCreated({});
      }
      if (!context.mounted) return;
      showCustomSnackBar(
        context,
        result.isEmpty ? S.of(context).teacherAssignedSuccessfully : result,
        true,
      );
    }
  }
}
