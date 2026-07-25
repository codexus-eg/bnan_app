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
  String? selectedStudentId;

  @override
  void didUpdateWidget(
    covariant CertificateStudentDropdown oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.classroomId == widget.classroomId) return;

    selectedStudentId = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onStudentSelected(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
        GetClassroomStudentsCubit,
        GetClassroomStudentsState>(
      builder: (context, state) {
        final classroomId = widget.classroomId?.trim();

        final hasClassroom =
            classroomId != null && classroomId.isNotEmpty;

        final isLoading =
            hasClassroom && state is GetClassroomStudentsLoading;

        final students =
            hasClassroom && state is GetClassroomStudentsSuccess
                ? state.response.data
                : <ClassroomStudentModel>[];

        final items = students
            .map((student) => student.id?.trim() ?? '')
            .where((id) => id.isNotEmpty)
            .toList();

        final hasStudents = items.isNotEmpty;

        final labels = {
          for (final student in students)
            if (student.id?.trim().isNotEmpty == true)
              student.id!.trim():
                  student.fullName?.trim() ?? '',
        };

        return AppSkeletonizer(
          isLoading: isLoading,
          child: CustomDropdown(
            value: selectedStudentId,
            label: S.of(context).student,
            isRequired: true,
            backgroundColor: ColorManager.white,
            hint: _getHint(
              context,
              hasClassroom: hasClassroom,
              hasStudents: hasStudents,
            ),
            hintStyle: StylesManager.styleBold14(
              context,
            ).copyWith(
              color: ColorManager.mainColor14,
            ),
            items: hasClassroom && hasStudents
                ? items
                : const [],
            itemsLabels: labels,
            onChanged: hasClassroom && hasStudents
                ? (studentId) {
                    _onStudentChanged(
                      context,
                      studentId,
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
    String? studentId,
  ) {
    final classroomId = widget.classroomId?.trim();
    final id = studentId?.trim();

    if (classroomId == null ||
        classroomId.isEmpty ||
        id == null ||
        id.isEmpty) {
      return;
    }

    setState(() {
      selectedStudentId = id;
    });

    widget.onStudentSelected(id);

    context.read<GetStudentSubjectsCubit>().reset();

    context.read<GetStudentSubjectsCubit>().getStudentSubjects(
      classroomId: classroomId,
      studentId: id,
    );
  }

  String _getHint(
    BuildContext context, {
    required bool hasClassroom,
    required bool hasStudents,
  }) {
    if (!hasClassroom) {
      return S.of(context).selectClassroomFirst;
    }

    if (!hasStudents) {
      return S.of(context).noStudentsInClass;
    }

    return S.of(context).selectStudent;
  }
}