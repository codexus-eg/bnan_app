import 'package:bnan_app/core/helper/currency_formatter.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_cubit.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/get_curriculm_subjects_cubit/get_curriculm_subjects_state.dart';
import 'package:bnan_app/features/student_auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:bnan_app/core/shared_widget/registration_review_line.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationReviewStep extends StatelessWidget {
  const RegistrationReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = RegisterCubit.get(context);
    final subjectsState = context.watch<GetCurriculmSubjectsCubit>().state;
    final subjects = subjectsState is GetSubjectsSuccess
        ? subjectsState.subjects
              .where((item) => cubit.selectedSubjectIds.contains(item.id))
              .map((item) => item.name)
              .join(', ')
        : '';
    final rows = <(String, String)>[
      (
        S.of(context).selectedPackage,
        '${cubit.packageName} — ${cubit.packagePrice} '
            '${CurrencyFormatter.symbol(context, cubit.packageCurrency)}',
      ),
      (S.of(context).email, cubit.parentEmailController.text.trim()),
      (S.of(context).studentName, cubit.studentNameController.text.trim()),
      (S.of(context).studentEmail, cubit.studentEmailController.text.trim()),
      (S.of(context).curriculum, cubit.curriculumName),
      (S.of(context).grade, cubit.selectedGradeName ?? ''),
      (S.of(context).subjects, subjects),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map((row) => RegistrationReviewLine(label: row.$1, value: row.$2))
          .toList(),
    );
  }
}
