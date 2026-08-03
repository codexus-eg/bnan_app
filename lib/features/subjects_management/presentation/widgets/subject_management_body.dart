import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/helper/my_snack_bar.dart';
import 'package:bnan_app/features/academic_lookups/data/repo/academic_lookups_repo.dart';
import 'package:bnan_app/features/academic_lookups/presentation/manager/academic_lookups_cubit.dart';
import 'package:bnan_app/features/subjects_management/data/models/subject_mock_data.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/get_subjects_cubit/get_subjects_state.dart';
import 'package:bnan_app/features/subjects_management/presentation/manager/subjects_actions_cubit/subject_actions_cubit.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/add_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/dialogs/edit_subject_dialog.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_card_management.dart';
import 'package:bnan_app/features/subjects_management/presentation/widgets/subject_management_header.dart';
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
                await context.read<GetSubjectsCubit>().getSubjects();
                if (!context.mounted) return;
                showCustomSnackBar(
                  context,
                  S.of(context).subjectCreatedSuccessfully,
                  true,
                );
              }
            },
          ),
          Expanded(
            child: BlocBuilder<GetSubjectsCubit, GetSubjectsState>(
              builder: (context, state) {
                final isLoading = state is GetSubjectsLoading;

                final subjects = state is GetSubjectsSuccess
                    ? state.subjects.data.reversed.toList()
                    : mockSubjects;

                if (state is GetSubjectsFailure) {
                  return const NoDataWidget();
                }

                if (!isLoading && subjects.isEmpty) {
                  return const NoDataWidget();
                }

                return AppSkeletonizer(
                  isLoading: isLoading,
                  child: ListView.separated(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      16,
                      16,
                      16,
                      24,
                    ),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];

                      return SubjectCardManagement(
                        subject: subject,
                        onEdit: isLoading
                            ? null
                            : () async {
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<SubjectActionsCubit>(),
                                    child: EditSubjectDialog(subject: subject),
                                  ),
                                );

                                if (result == true && context.mounted) {
                                  context
                                      .read<GetSubjectsCubit>()
                                      .getSubjects();
                                }
                              },
                      );
                    },
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemCount: subjects.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
