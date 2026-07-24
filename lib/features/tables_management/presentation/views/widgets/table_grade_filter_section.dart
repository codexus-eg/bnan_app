import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/grade_filter_dropdown.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableGradeFilterSection extends StatelessWidget {
  const TableGradeFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            start: 16,
            end: 16,
          ),
          child: GradeFilterDropdown(
            grades: state.grades,
            selectedGrade: state.selectedGrade,
            isLoading: state.isLoadingGrades,
            backgroundColor: ColorManager.white,
            onChanged: (grade) => _selectGrade(context, grade),
          ),
        );
      },
    );
  }

  void _selectGrade(BuildContext context, AcademicGradeModel? grade) {
    context.read<AcademicLookupsCubit>().selectGrade(grade);
    context.read<GetEgyptianSchedulesCubit>().getEgyptianSchedules(
      gradeId: grade?.id,
    );
  }
}
