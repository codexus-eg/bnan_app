import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/academic_lookups/data/models/academic_grade_model.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_state.dart';
import 'package:bnan_app/features/academic_lookups/presentation/widgets/grade_filter_dropdown.dart';
import 'package:bnan_app/features/certificates_management/presentation/manager/get_monthly_certificates_cubit/get_monthly_certificates_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseGradeCertificate extends StatelessWidget {
  const ChooseGradeCertificate({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradeFilterDropdown(
                grades: state.grades,
                selectedGrade: state.selectedGrade,
                isLoading: state.isLoadingGrades,
                backgroundColor: ColorManager.white,
                onChanged: (grade) => _selectGrade(context, grade),
              ),
              const SizedBox(height: 16),
              Text(
                _title(context, state.selectedGrade),
                style: StylesManager.styleBold14(
                  context,
                ).copyWith(color: ColorManager.mainColor15),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _selectGrade(BuildContext context, AcademicGradeModel? grade) {
    context.read<AcademicLookupsCubit>().selectGrade(grade);
    context.read<GetMonthlyCertificatesCubit>().getMonthlyCertificates(
      gradeId: grade?.id,
    );
  }

  String _title(BuildContext context, AcademicGradeModel? selectedGrade) {
    if (selectedGrade == null) {
      return '${S.of(context).certificatesWithoutArticle} '
          '${S.of(context).allStudents}';
    }

    return '${S.of(context).certificatesWithoutArticle} '
        '${S.of(context).students} ${selectedGrade.displayName}';
  }
}
