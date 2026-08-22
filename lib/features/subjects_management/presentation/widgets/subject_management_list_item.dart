import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_response_model.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/edit_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_card_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectManagementListItem extends StatelessWidget {
  const SubjectManagementListItem({
    super.key,
    required this.subject,
    required this.enabled,
  });

  final SubjectModel subject;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SubjectCardManagement(
      subject: subject,
      onEdit: enabled ? () => _editSubject(context) : null,
    );
  }

  Future<void> _editSubject(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<SubjectActionsCubit>()),
          BlocProvider(
            create: (_) => AcademicLookupsCubit(
              repo: getIt<AcademicLookupsRepo>(),
              loadClassroomsOnGrade: false,
              loadSubjectsWithoutClassroom: false,
              loadSubjectsOnClassroom: false,
            ),
          ),
        ],
        child: EditSubjectDialog(subject: subject),
      ),
    );
    if (result == true && context.mounted) {
      await context.read<GetSubjectsCubit>().refreshSubjects();
    }
  }
}
