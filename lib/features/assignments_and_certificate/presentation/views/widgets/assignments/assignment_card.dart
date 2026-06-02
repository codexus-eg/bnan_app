import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/assignments_and_certificate/data/assignment_model.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignment_action_buttons.dart';
import 'package:bnan_app/features/assignments_and_certificate/presentation/views/widgets/assignments/assignment_status_badge.dart';
import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({super.key, required this.assignment});

  final AssignmentModel assignment;

bool get showSubmit => assignment.canSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(8),
      margin: EdgeInsetsDirectional.only(bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.subject, style: _lightStyle(context)),
                  const SizedBox(height: 8),
                  Text(assignment.title, style: StylesManager.styleBold16(context).copyWith(
                    color: ColorManager.mainColor14
                  )),
                  const SizedBox(height: 8),
                  Text(assignment.dueDate, style: _lightStyle(context)),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: AssignmentStatusBadge(text: assignment.badgeText),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AssignmentActionButtons(
            showSubmit: showSubmit,
            onDownload: () {},
            onSubmit: () {},
          ),
        ],
      ),
    );
  }

  TextStyle _lightStyle(BuildContext context) {
    return StylesManager.styleRegular14(context).copyWith(
      color: ColorManager.greyA8AF,
    );
  }
}