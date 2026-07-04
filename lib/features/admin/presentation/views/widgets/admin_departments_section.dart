import 'package:bnan_app/features/admin/data/admin_students_mock.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_department_progress_item.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_department_title.dart';
import 'package:flutter/material.dart';

class AdminDepartmentsSection extends StatelessWidget {
  const AdminDepartmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final departments = adminDepartmentProgress(context);
    return Column(
      children: [
       AdminDepartmentTitle(),
        const SizedBox(height: 8),
        ...departments.map(
          (department) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 16),
            child: AdminDepartmentProgressItem(department: department),
          ),
        ),
      ],
    );
  }
}
