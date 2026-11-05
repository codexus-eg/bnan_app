import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/classrooms_management/data/models/classroom_assigned_subject.dart';
import 'package:flutter/material.dart';

class ClassroomSubjectItemCard extends StatelessWidget {
  const ClassroomSubjectItemCard({
    super.key,
    required this.subject,
    required this.onDelete,
    this.enabled = true,
  });

  final ClassroomAssignedSubject subject;
  final VoidCallback onDelete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final teacher = subject.teacherName?.trim();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorManager.greyF8F9,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(subject.name,
                    style: StylesManager.styleBold12(context)
                        .copyWith(color: ColorManager.mainColor14)),
                if (teacher != null && teacher.isNotEmpty)
                  Text(teacher,
                      style: StylesManager.styleRegular10(context)
                          .copyWith(color: ColorManager.grey7A7C)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: ColorManager.red, size: 20),
            onPressed: enabled ? onDelete : null,
          ),
        ],
      ),
    );
  }
}
