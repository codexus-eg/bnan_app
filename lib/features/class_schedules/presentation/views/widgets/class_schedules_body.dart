import 'package:bnan_app/features/class_schedules/data/models/class_schedules_dummy_data.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/add_class_schedule_button.dart';
import 'package:bnan_app/features/class_schedules/presentation/views/widgets/class_schedule_card.dart';
import 'package:flutter/material.dart';

class ClassSchedulesBody extends StatelessWidget {
  const ClassSchedulesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: classSchedulesDummyData.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) return const AddClassScheduleButton();
        return ClassScheduleCard(schedule: classSchedulesDummyData[index - 1]);
      },
    );
  }
}
