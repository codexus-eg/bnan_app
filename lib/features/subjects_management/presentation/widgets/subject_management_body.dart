import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/add_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_header.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_list.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectManagementBody extends StatelessWidget {
  const SubjectManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SubjectManagementHeader(
            onAddTap: () async {
              final subjectActionsCubit = context.read<SubjectActionsCubit>();
              final result = await showDialog<bool>(
                context: context,
                builder: (_) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: subjectActionsCubit),
                      BlocProvider(
                        create: (_) => AcademicLookupsCubit(
                          repo: getIt<AcademicLookupsRepo>(),
                          loadClassroomsOnGrade: false,
                          loadSubjectsWithoutClassroom: false,
                          loadSubjectsOnClassroom: false,
                        ),
                      ),
                    ],
                    child: const AddSubjectDialog(),
                  );
                },
              );

              if (result == true && context.mounted) {
                await context.read<GetSubjectsCubit>().refreshSubjects();
                if (!context.mounted) return;
                showCustomSnackBar(
                  context,
                  S.of(context).subjectCreatedSuccessfully,
                  true,
                );
              }
            },
          ),
          const Expanded(child: SubjectManagementList()),
        ],
      ),
    );
  }
}
