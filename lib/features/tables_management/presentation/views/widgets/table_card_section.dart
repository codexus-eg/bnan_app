import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/tables_management/data/models/class_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TableCardSection extends StatelessWidget {
  const TableCardSection({super.key, required this.scheduleModel});
  final ClassScheduleModel scheduleModel;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.asset(
              scheduleModel.imagePath,
              height: 193,
              width: double.infinity,
              fit: BoxFit.cover,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheduleModel.curriculum,
                      style: StylesManager.styleRegular10(
                        context,
                      ).copyWith(color: ColorManager.mainColor14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${scheduleModel.grade} - ${scheduleModel.subject}',
                      style: StylesManager.styleBold12(
                        context,
                      ).copyWith(color: ColorManager.greyA8AF),
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(ImageManager.trash, height: 24, width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
