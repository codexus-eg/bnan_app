import 'package:bnan_app/features/academic_lookups/data/models/academic_lookup_selection.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/classroom_lookup_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/curriculum_lookup_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/grade_lookup_dropdown.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/subject_lookup_dropdown.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicLookupDropdowns extends StatefulWidget {
  const AcademicLookupDropdowns({
    super.key,
    this.showCurriculum = true,
    this.showGrade = true,
    this.showClassroom = true,
    this.showSubject = true,
    required this.onSelectionChanged,
  });

  final bool showCurriculum;
  final bool showGrade;
  final bool showClassroom;
  final bool showSubject;
  final ValueChanged<AcademicLookupSelection> onSelectionChanged;

  @override
  State<AcademicLookupDropdowns> createState() =>
      _AcademicLookupDropdownsState();
}

class _AcademicLookupDropdownsState extends State<AcademicLookupDropdowns> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AcademicLookupsCubit>().loadCurriculums();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AcademicLookupsCubit, AcademicLookupsState>(
      listenWhen: (previous, current) =>
          previous.selectedCurriculum?.id != current.selectedCurriculum?.id ||
          previous.selectedGrade?.id != current.selectedGrade?.id ||
          previous.selectedClassroom?.id != current.selectedClassroom?.id ||
          previous.selectedSubject?.id != current.selectedSubject?.id,
      listener: (_, state) => widget.onSelectionChanged(state.selection),
      child: BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
        buildWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        builder: (context, state) {
          return Column(children: _children(context, state.errorMessage));
        },
      ),
    );
  }

  List<Widget> _children(BuildContext context, String? errorMessage) {
    final children = <Widget>[];
    void add(Widget child) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 16));
      children.add(child);
    }

    if (widget.showCurriculum) add(const CurriculumLookupDropdown());
    if (widget.showGrade) add(const GradeLookupDropdown());
    if (widget.showClassroom) add(const ClassroomLookupDropdown());
    if (widget.showSubject) {
      add(SubjectLookupDropdown(requiresClassroom: widget.showClassroom));
    }
    if (errorMessage != null) {
      add(
        Text(
          errorMessage,
          style: StylesManager.styleRegular12(
            context,
          ).copyWith(color: Colors.red),
        ),
      );
    }
    return children;
  }
}
