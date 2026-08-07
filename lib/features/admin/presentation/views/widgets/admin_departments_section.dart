import 'package:bnan_app/features/admin/data/models/admin_students_by_section_model.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_department_progress_item.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_department_title.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_departments_mapper.dart';
import 'package:flutter/material.dart';

class AdminDepartmentsSection extends StatelessWidget {
  const AdminDepartmentsSection({super.key, required this.data});
  final AdminStudentsBySectionModel data;

  @override
  Widget build(BuildContext context) {
    final departments = adminDepartments(context, data);
    return Column(
      children: [
        const AdminDepartmentTitle(),
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
