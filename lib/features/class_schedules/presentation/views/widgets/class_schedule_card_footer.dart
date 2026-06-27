import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/class_schedules/data/models/class_schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ClassScheduleCardFooter extends StatelessWidget {
  const ClassScheduleCardFooter({super.key, required this.schedule});

  final ClassScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.curriculum,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleRegular10(context),
                ),
                Text(
                  schedule.gradeLabel,
                  overflow: TextOverflow.ellipsis,
                  style: StylesManager.styleBold12(
                    context,
                  ).copyWith(color: ColorManager.greyA8AF),
                ),
              ],
            ),
          ),
          Spacer(),
          SvgPicture.asset(ImageManager.trash, width: 22),
          
        ],
      ),
    );
  }
}
