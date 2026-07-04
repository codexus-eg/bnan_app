import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/admin/data/models/admin_department_progress_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

List<AdminDepartmentProgressModel> adminDepartmentProgress(
  BuildContext context,
) {
  final s = S.of(context);
  return [
    AdminDepartmentProgressModel(
      title: s.egyptianDepartment,
      current: 18,
      total: 29,
      progress: .62,
      color: ColorManager.orangeE4,
    ),
    AdminDepartmentProgressModel(
      title: s.saudiDepartment,
      current: 18,
      total: 29,
      progress: .62,
      color: ColorManager.mainColor14,
    ),
  ];
}
