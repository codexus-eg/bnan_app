import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/certificates_management/data/models/classroom_students_response_model.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_cubit.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_classroom_students_cubit/get_classroom_students_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_student_subjects_cubit/get_student_subjects_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertificateStudentDropdown extends StatefulWidget {
  const CertificateStudentDropdown({
    super.key,
    required this.classroomId,
    required this.onStudentSelected,
  });

  final String? classroomId;
  final ValueChanged<String?> onStudentSelected;

  @override
  State<CertificateStudentDropdown> createState() =>
      _CertificateStudentDropdownState();
}

class _CertificateStudentDropdownState
    extends State<CertificateStudentDropdown> {
  String? selectedStudentName;

  @override
  void didUpdateWidget(
    covariant CertificateStudentDropdown oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.classroomId == widget.classroomId) return;

    selectedStudentName = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onStudentSelected(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GetClassroomStudentsCubit,
      GetClassroomStudentsState
    >(
      builder: (context, state) {
        final isLoading = state is GetClassroomStudentsLoading;

        final students = state is GetClassroomStudentsSuccess
            ? state.response.data
            : <ClassroomStudentModel>[];

        final hasStudents = students.isNotEmpty;

        final names = isLoading
            ? ['Student name']
            : hasStudents
                ? students
                    .map(
                      (student) =>
                          student.fullName?.trim() ?? '',
                    )
                    .where((name) => name.isNotEmpty)
                    .toList()
                : [S.of(context).noStudentsInClass];

        return AppSkeletonizer(
          isLoading: isLoading,
          child: CustomDropdown(
            value: selectedStudentName,
            hint: S.of(context).student,
            isRequired: true,
            items: names,
            label: S.of(context).student,
            backgroundColor: ColorManager.white,
            hintStyle: StylesManager.styleBold14(
              context,
            ).copyWith(
              color: ColorManager.mainColor14,
            ),
            onChanged: hasStudents
                ? (name) {
                    _onStudentChanged(
                      context,
                      name,
                      students,
                    );
                  }
                : null,
          ),
        );
      },
    );
  }

  void _onStudentChanged(
    BuildContext context,
    String? name,
    List<ClassroomStudentModel> students,
  ) {
    final classroomId = widget.classroomId?.trim();

    if (classroomId == null ||
        classroomId.isEmpty ||
        name == null ||
        name.trim().isEmpty) {
      return;
    }

    final student = students.firstWhere(
      (student) => student.fullName?.trim() == name.trim(),
    );

    final studentId = student.id?.trim();

    if (studentId == null || studentId.isEmpty) return;

    setState(() {
      selectedStudentName = name;
    });

    widget.onStudentSelected(studentId);

    context.read<GetStudentSubjectsCubit>().reset();

    context.read<GetStudentSubjectsCubit>().getStudentSubjects(
      classroomId: classroomId,
      studentId: studentId,
    );
  }
}