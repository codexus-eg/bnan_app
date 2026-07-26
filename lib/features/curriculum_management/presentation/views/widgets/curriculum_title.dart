import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/curriculum_management/data/models/curriculum_model.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/curriculum_actions_cubit/curriculum_actions_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/manager/get_curriculums_cubit/get_curriculums_cubit.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/add_curriculms_data_title.dart';
import 'package:bnan_app/features/curriculum_management/presentation/views/widgets/dialogs/curriculm_form_dialog.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurriculumTitle extends StatelessWidget {
  const CurriculumTitle({super.key, required this.curriculum});
  final CurriculumModel curriculum;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          ImageManager.teacherCurriculm,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            ColorManager.mainColor14,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        AddCurriculmsDataTitle(
          title: curriculum.name,
          subtitle: S.of(context).gradesCount(curriculum.gradesCount ?? 0),
        ),
        Spacer(),
        IconButton(
          onPressed: () => _showEditCurriculumDialog(context),
          icon: SvgPicture.asset(ImageManager.edit, height: 20, width: 20),
          color: ColorManager.greyA8AF,
        ),
      ],
    );
  }

  Future<void> _showEditCurriculumDialog(BuildContext context) async {
    final actionsCubit = context.read<CurriculumActionsCubit>();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: actionsCubit,
        child: CurriculumFormDialog(curriculum: curriculum),
      ),
    );

    if (result == true && context.mounted) {
      context.read<GetCurriculumsCubit>().getCurriculums();
    }
  }
}
