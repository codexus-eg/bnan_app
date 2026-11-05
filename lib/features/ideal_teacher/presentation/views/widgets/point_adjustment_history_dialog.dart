import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_delete_dialog.dart';
import 'package:bnan_app/core/shared_widget/dialogs/custom_dialog_header.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_cubit.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/manager/supervisor_ideal_teacher_state.dart';
import 'package:bnan_app/features/ideal_teacher/presentation/policies/ideal_teacher_access_policy.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointAdjustmentHistoryDialog extends StatefulWidget {
  const PointAdjustmentHistoryDialog({
    super.key,
    required this.teacherId,
    required this.teacherName,
  });

  final String teacherId, teacherName;

  static Future<void> show(
    BuildContext context, {
    required String teacherId,
    required String teacherName,
  }) => showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<SupervisorIdealTeacherCubit>(),
      child: PointAdjustmentHistoryDialog(
        teacherId: teacherId,
        teacherName: teacherName,
      ),
    ),
  );

  @override
  State<PointAdjustmentHistoryDialog> createState() =>
      _PointAdjustmentHistoryDialogState();
}

class _PointAdjustmentHistoryDialogState
    extends State<PointAdjustmentHistoryDialog> {
  @override
  void initState() {
    super.initState();
    context.read<SupervisorIdealTeacherCubit>().loadPointAdjustments(
      widget.teacherId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final canModify =
        IdealTeacherAccessPolicy.canModify(SessionManager.instance.role);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDialogHeader(title: s.pointAdjustmentHistory),
            const SizedBox(height: 8),
            Text(
              widget.teacherName,
              style: StylesManager.styleBold14(
                context,
              ).copyWith(color: ColorManager.mainColor14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 380),
              child: BlocBuilder<SupervisorIdealTeacherCubit,
                  SupervisorIdealTeacherState>(
                builder: (context, state) {
                  if (state.loadingAdjustments) {
                    return const AppSkeletonizer(
                      isLoading: true,
                      child: SizedBox(height: 120),
                    );
                  }
                  if (state.adjustments.isEmpty) {
                    return NoDataWidget(title: s.pointAdjustments);
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.adjustments.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.adjustments[index];
                      return _AdjustmentItem(
                        item: item,
                        canModify: canModify,
                        onRevoke: () => _confirmRevoke(item),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmRevoke(PointAdjustmentModel item) async {
    final s = S.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => CustomDeleteDialog(
        gradeId: item.id,
        isLoading: false,
        showCancelButton: true,
        dialogHeader: s.revokePointAdjustment,
        subtitle: s.confirmRevokePointAdjustment,
        onPressed: () => Navigator.pop(context, true),
      ),
    );

    if (confirmed == true && mounted) {
      final success = await context
          .read<SupervisorIdealTeacherCubit>()
          .revokePointAdjustment(
            adjustmentId: item.id,
            teacherId: widget.teacherId,
          );
      if (mounted && success) {
        showCustomSnackBar(context, s.pointAdjustmentRevokedSuccessfully, true);
      }
    }
  }
}

class _AdjustmentItem extends StatelessWidget {
  const _AdjustmentItem({
    required this.item,
    required this.canModify,
    required this.onRevoke,
  });

  final PointAdjustmentModel item;
  final bool canModify;
  final VoidCallback onRevoke;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final categoryText = switch (item.category) {
      'interactive_environment' => s.interactiveEnvironment,
      'weekly_tasks' => s.weeklyTasks,
      'effort' => s.effort,
      _ => s.other,
    };

    return CustomDetailsWidgetBackground(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '+${item.points} ($categoryText)',
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              StatusBadge(
                text: item.isActive ? s.activeStatus : s.revokedStatus,
              ),
            ],
          ),
          if (item.reason.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(item.reason, style: StylesManager.styleRegular12(context)),
          ],
          if (item.awardedByName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.awardedByName,
              style: StylesManager.styleRegular10(context).copyWith(
                color: ColorManager.grey7A7C,
              ),
            ),
          ],
          if (item.isActive && canModify) ...[
            const SizedBox(height: 6),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                onTap: onRevoke,
                child: Text(
                  s.revoke,
                  style: StylesManager.styleBold12(
                    context,
                  ).copyWith(color: ColorManager.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
