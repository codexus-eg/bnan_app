import 'package:bnan_app/features/admin/data/admin_students_mock.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_department_progress_item.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_section_title.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminDepartmentsSection extends StatelessWidget {
  const AdminDepartmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final departments = adminDepartmentProgress(context);
    return Column(
      children: [
        AdminSectionTitle(title: S.of(context).studentsByDepartment),
        const SizedBox(height: 8),
        ...departments.map(
          (department) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: AdminDepartmentProgressItem(department: department),
          ),
        ),
      ],
    );
  }
}
