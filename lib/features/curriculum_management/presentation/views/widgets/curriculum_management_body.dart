import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/curriculum_list_bloc_builder.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/dialogs/curriculm_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumManagementBody extends StatelessWidget {
  const CurriculumManagementBody({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: AddNewTopicButton(
            padding: const EdgeInsetsDirectional.only(
              start: 17.5,
              end: 24.5,
              top: 8,
              bottom: 8,
            ),
            title: s.addNewCurriculum,
            path: ImageManager.plus,
            onTap: () => _showCurriculumDialog(context),
          ),
        ),
        const Expanded(child: CurriculumListBlocBuilder()),
      ],
    );
  }

  Future<void> _showCurriculumDialog(BuildContext context) async {
    final actionsCubit = context.read<CurriculumActionsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: actionsCubit,
        child: const CurriculumFormDialog(),
      ),
    );

    if (result == true && context.mounted) {
      context.read<GetCurriculumsCubit>().getCurriculums();
    }
  }
}
