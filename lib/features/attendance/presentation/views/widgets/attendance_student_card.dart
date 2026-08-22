import 'package:bnan_app/core/shared_widget/custom_avatar.dart';
import 'package:bnan_app/core/shared_widget/selection_circle.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_lookup_models.dart';
import 'package:bnan_app/features/attendance/data/models/attendance_status.dart';
import 'package:bnan_app/features/attendance/presentation/manager/attendance_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceStudentCard extends StatelessWidget {
  const AttendanceStudentCard({
    super.key,
    required this.student,
    required this.subtitle,
  });
  final AttendanceStudent student;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (AttendanceCubit cubit) =>
          cubit.state.statusByStudentId[student.id] ?? AttendanceStatus.present,
    );
    final labels = {
      AttendanceStatus.present.name: S.of(context).evaluationPresent,
      AttendanceStatus.absent.name: S.of(context).evaluationAbsent,
      AttendanceStatus.late.name: S.of(context).evaluationLate,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorManager.greyE8E9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomAvatar(
                firstName: student.name,
                radius: 23,
                backgroundColor: ColorManager.blueE3,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StylesManager.styleBold14(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StylesManager.styleRegular12(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            key: Key('attendance-status-${student.id}'),
            spacing: 16,
            runSpacing: 8,
            children: AttendanceStatus.values
                .map(
                  (item) => GestureDetector(
                    onTap: () => context.read<AttendanceCubit>().updateStatus(
                      student.id,
                      item,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectionCircle(isSelected: status == item),
                        const SizedBox(width: 6),
                        Text(
                          labels[item.name]!,
                          style: StylesManager.styleRegular12(context),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
