import 'package:bnan_app/features/academic_lookups/data/models/academic_subject_model.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/subject_selection_list.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalSubjectStep extends StatelessWidget {
  const RenewalSubjectStep({super.key});
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<ParentSubscriptionRenewalCubit>();
    if (!cubit.state.isSingleSubject) {
      return Text(S.of(context).renewalAllSubjectsNoSelection);
    }
    final subjects = cubit.state.args.subjects
        .map((item) => AcademicSubjectModel(id: item.id, name: item.name))
        .toList();
    return SubjectSelectionList(
      subjects: subjects,
      selectedSubjectIds: cubit.state.subjectId == null
          ? const []
          : [cubit.state.subjectId!],
      selectionMode: SubjectSelectionMode.single,
      onChanged: (values) {
        if (values.isNotEmpty) cubit.selectSubject(values.single);
      },
    );
  }
}
