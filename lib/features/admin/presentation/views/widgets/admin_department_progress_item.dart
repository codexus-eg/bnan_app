import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_department_progress_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminDepartmentProgressItem extends StatelessWidget {
  const AdminDepartmentProgressItem({super.key, required this.department});

  final AdminDepartmentProgressModel department;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                department.title,
                overflow: TextOverflow.ellipsis,
                style: StylesManager.styleRegular12(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
            ),
            Text(
              '${department.current} ${S.of(context).student} • '
              '${department.percentageLabel}%',
              style: StylesManager.styleRegular12(
                context,
              ).copyWith(color: ColorManager.mainColor14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: department.progress,
            minHeight: 6.5,
            color: department.color,
            borderRadius: BorderRadius.circular(6),
            backgroundColor: ColorManager.greyE8E9,
          ),
        ),
      ],
    );
  }
}
