import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_department_progress_model.dart';
import 'package:flutter/material.dart';

class AdminDepartmentProgressItem extends StatelessWidget {
  const AdminDepartmentProgressItem({super.key, required this.department});

  final AdminDepartmentProgressModel department;

  @override
  Widget build(BuildContext context) {
    final percent = (department.progress * 100).round();
    return Column(
      children: [
        Row(
          children: [
            Text(
              '($percent%)${department.current}',
              style: StylesManager.styleRegular10(context),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                department.title,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: department.progress,
            minHeight: 5,
            color: department.color,
            backgroundColor: ColorManager.greyE8E9,
          ),
        ),
      ],
    );
  }
}
