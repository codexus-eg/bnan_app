import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/supervisor_classroom_assignment/data/models/get_supervisors_response_model.dart';
import 'package:flutter/material.dart';

class IdealSupervisorCard extends StatelessWidget {
  const IdealSupervisorCard({
    super.key,
    required this.supervisor,
    required this.selected,
    required this.onTap,
  });
  final SupervisorModel supervisor;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: CustomDetailsWidgetBackground(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: const EdgeInsetsDirectional.all(12),
      backgroundColor: selected ? ColorManager.blueE5 : ColorManager.greyF8F9,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supervisor.user?.fullName ?? '-',
                  style: StylesManager.styleBold14(context),
                ),
                if (supervisor.user?.email.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    supervisor.user!.email,
                    style: StylesManager.styleRegular12(context),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SelectionCircle(isSelected: selected),
        ],
      ),
    ),
  );
}
