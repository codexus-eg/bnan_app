import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TableCardSection extends StatelessWidget {
  const TableCardSection({
    super.key,
    required this.schedule,
    this.onDelete,
    this.showAcademicDetails = false,
  });

  final EgyptianScheduleModel schedule;
  final VoidCallback? onDelete;
  final bool showAcademicDetails;

  @override
  Widget build(BuildContext context) {
    final classroomName =
        schedule.classroom?.name ?? S.of(context).classSchedulesManagement;
    final scheduleId = schedule.id ?? '';
    final academicDetails = [
      schedule.grade?.name,
      schedule.curriculum?.name,
    ].whereType<String>().where((value) => value.isNotEmpty).join(' • ');
    final subtitle = showAcademicDetails && academicDetails.isNotEmpty
        ? academicDetails
        : scheduleId;

    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          NetworkAttachmentPreview(
            attachmentUrl: schedule.image ?? '',
            height: 193,
            fit: BoxFit.cover,
            title: classroomName,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 8,
              end: 9,
              top: 13,
              bottom: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        classroomName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StylesManager.styleRegular10(
                          context,
                        ).copyWith(color: ColorManager.mainColor14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StylesManager.styleBold12(
                          context,
                        ).copyWith(color: ColorManager.greyA8AF),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (onDelete != null)
                  InkWell(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      ImageManager.trash,
                      height: 24,
                      width: 24,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
