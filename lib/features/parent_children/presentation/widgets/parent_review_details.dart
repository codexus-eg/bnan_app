import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/core/shared_widget/registration_review_line.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentReviewDetails extends StatelessWidget {
  const ParentReviewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ParentAddChildCubit>().state;
    final subjects = context
        .watch<AcademicLookupsCubit>()
        .state
        .subjects
        .where((item) => state.selectedSubjectIds.contains(item.id))
        .map((item) => item.name)
        .join(', ');
    final rows = <(String, String)>[
      (S.of(context).studentName, state.fullName),
      (S.of(context).studentEmail, state.email),
      (S.of(context).curriculum, state.curriculum?.name ?? ''),
      (S.of(context).grade, state.grade?.name ?? ''),
      if (state.requiresSubjectSelection) (S.of(context).subjects, subjects),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows
          .map((row) => RegistrationReviewLine(label: row.$1, value: row.$2))
          .toList(),
    );
  }
}
