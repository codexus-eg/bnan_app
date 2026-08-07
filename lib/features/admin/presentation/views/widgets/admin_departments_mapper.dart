import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_students_by_section_model.dart';
import 'package:bnan_app/features/admin/data/models/admin_department_progress_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<AdminDepartmentProgressModel> adminDepartments(
  BuildContext context,
  AdminStudentsBySectionModel data,
) {
  final s = S.of(context);
  return data.sections
      .where((section) => section.key == 'egyptian' || section.key == 'gulf')
      .map(
        (section) => AdminDepartmentProgressModel(
          title: section.key == 'egyptian'
              ? s.egyptianDepartment
              : s.saudiDepartment,
          current: section.count,
          total: data.total,
          percentage: section.percentage,
          color: section.key == 'egyptian'
              ? ColorManager.orangeE4
              : ColorManager.mainColor14,
        ),
      )
      .toList();
}
