import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/student_classroom_assignment/data/models/unassigned_student_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class StudentPickerSheet extends StatefulWidget {
  const StudentPickerSheet({super.key, required this.students});

  final List<UnassignedStudentModel> students;

  @override
  State<StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<StudentPickerSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final normalizedQuery = query.trim().toLowerCase();
    final students = widget.students
        .where((student) {
          return student.fullName.trim().toLowerCase().contains(
            normalizedQuery,
          );
        })
        .toList(growable: false);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          20,
          16,
          MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          children: [
            CustomTextField(
              label: s.student,
              hintText: s.searchForStudent,
              onChanged: (value) => setState(() => query = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: students.isEmpty
                  ? Center(child: Text(s.noStudentWithThisName))
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.pop(context, students[index]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            students[index].fullName,
                            style: StylesManager.styleRegular16(
                              context,
                            ).copyWith(color: ColorManager.mainColor15),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
