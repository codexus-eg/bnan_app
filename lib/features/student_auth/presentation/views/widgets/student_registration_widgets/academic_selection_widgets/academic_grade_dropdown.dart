import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/features/payments/presentation/manager/discount_preview_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/grades_management/data/models/grade_model.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_grades_cubit/get_grades_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicGradeDropdown extends StatelessWidget {
  const AcademicGradeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();
    return BlocBuilder<GetGradesCubit, GetGradesState>(
      builder: (context, state) {
        final grades = state is GetGradesSuccess ? state.grades : <GradeModel>[];
        final items = grades.map((g) => g.name).toList();
        return CustomDropdown(
          label: S.of(context).grade,
          value: cubit.selectedGradeName,
          hint: S.of(context).selectGrade,
          items: items,
          isRequired: true,
          enabled: cubit.curriculumId.isNotEmpty,
          onChanged: (name) => _onChanged(context, cubit, grades, name),
        );
      },
    );
  }

  Future<void> _onChanged(BuildContext context, RegisterCubit cubit, List<GradeModel> grades, String? name) async {
    if (name == null) return;
    final grade = grades.firstWhere((g) => g.name == name);
    context.read<TamaraPaymentCubit>().invalidateAmountSummary();
    context.read<DiscountPreviewCubit>().invalidate();
    cubit.setGrade(id: grade.id, name: grade.name);
    final subs = context.read<GetCurriculmSubjectsCubit>();
    await subs.getCurriculumSubjects(curriculumId: cubit.curriculumId, gradeId: grade.id, isGulf: cubit.isGulf);
    if (context.mounted && subs.state is GetSubjectsSuccess) {
      cubit.setAllSubjectIds((subs.state as GetSubjectsSuccess).subjects.map((s) => s.id));
    }
  }
}
