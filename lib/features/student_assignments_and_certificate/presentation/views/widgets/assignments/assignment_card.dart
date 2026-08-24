import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/data/models/student_assignment_model.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignment_card_actions_handler.dart';
import 'package:bnan_app/core/shared_widget/status_badge.dart';
import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({
    super.key,
    required this.assignment,
    this.isLoading = false,
  });

  final AssignmentModel assignment;
  final bool isLoading;

  bool get showSubmit => assignment.canSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withAlpha((255 * .25).round()),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AssignmentCardHeader(assignment: assignment),
          // if (assignment.attachment.trim().isNotEmpty) ...[
          //   const SizedBox(height: 8),
          //   AssignmentAttachmentPreview(assignment: assignment),
          // ],
          const SizedBox(height: 8),
          AssignmentCardActionsHandler(
            assignment: assignment,
            showSubmit: showSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

class _AssignmentCardHeader extends StatelessWidget {
  const _AssignmentCardHeader({
    required this.assignment,
  });

  final AssignmentModel assignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(assignment.subject, style: _lightStyle(context)),
              const SizedBox(height: 8),
              Text(
                assignment.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleBold16(context).copyWith(
                  color: ColorManager.mainColor14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assignment.dueDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _lightStyle(context),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        StatusBadge(text: assignment.badgeText),
      ],
    );
  }

  TextStyle _lightStyle(BuildContext context) {
    return StylesManager.styleRegular14(context).copyWith(
      color: ColorManager.greyA8AF,
    );
  }
}
