import 'package:bnan_app/core/shared_widget/custom_dropdown.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ChooseGradeCertificate extends StatelessWidget {
  const ChooseGradeCertificate({super.key});

  static const allGrades = 'كل الصفوف';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademicLookupsCubit, AcademicLookupsState>(
      builder: (context, state) {
        final items = [
          allGrades,
          ...state.grades.map((grade) => grade.displayName),
        ];

        return Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 16,
            start: 16,
            end: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomDropdown(
                backgroundColor: ColorManager.white,
                label: S.of(context).chooseGrade,
                value: state.selectedGrade?.displayName ?? allGrades,
                items: items,
                onChanged: (value) => _selectGrade(
                  context,
                  value,
                  state.grades,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _title(context, state.selectedGrade),
                style: StylesManager.styleBold14(context).copyWith(
                  color: ColorManager.mainColor15,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _selectGrade(
    BuildContext context,
    String? value,
    List<AcademicGradeModel> grades,
  ) {
    if (value == null) return;

    if (value == allGrades) {
      context.read<AcademicLookupsCubit>().selectGrade(null);
      context
          .read<GetMonthlyCertificatesCubit>()
          .getMonthlyCertificates();
      return;
    }

    final selectedGrade = grades.firstWhere(
      (grade) => grade.displayName == value,
    );

    context.read<AcademicLookupsCubit>().selectGrade(selectedGrade);

    context
        .read<GetMonthlyCertificatesCubit>()
        .getMonthlyCertificates(
          gradeId: selectedGrade.id,
        );
  }

  String _title(
    BuildContext context,
    AcademicGradeModel? selectedGrade,
  ) {
    if (selectedGrade == null) {
      return '${S.of(context).certificatesWithoutArticle} كل الطلاب';
    }

    return '${S.of(context).certificatesWithoutArticle} طلاب ${selectedGrade.displayName}';
  }
}