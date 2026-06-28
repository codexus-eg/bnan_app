import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/class_schedules/data/models/class_schedule_model.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/class_schedule_card_footer.dart';
import 'package:flutter/material.dart';

class ClassScheduleCard extends StatelessWidget {
  const ClassScheduleCard({super.key, required this.schedule});

  final ClassScheduleModel schedule;

  @override
  Widget build(BuildContext context) {
    return CustomDetailsWidgetBackground(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              schedule.previewImage,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * (170 / 812),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 170,
                alignment: Alignment.center,
                color: ColorManager.greyF8F9,
                child: const Icon(Icons.broken_image_outlined),
              ),
            ),
          ),
          ClassScheduleCardFooter(schedule: schedule),
        ],
      ),
    );
  }
}
