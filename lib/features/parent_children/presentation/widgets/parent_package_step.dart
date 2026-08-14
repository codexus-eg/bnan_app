import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_curriculum_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentPackageStep extends StatelessWidget {
  const ParentPackageStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ParentAddChildCubit>().state;
    final curriculum = state.curriculum;
    return Column(
      children: [
        if (curriculum == null) const ParentCurriculumField(),
        if (curriculum != null)
          SubscriptionGrid(
            curriculumId: curriculum.id,
            curriculumName: curriculum.name,
            registrationMode: curriculum.registrationMode,
            selectedPackageId: state.package?.id,
            isSliver: false,
            packageFilter: (item) => ParentPackagePolicy.isVisible(
              item,
              registrationMode: curriculum.registrationMode,
            ),
            bottomWidget: (_, item) {
              final selected = state.package?.id == item.id;
              return CustomAppButton(
                height: 38,
                text: S.of(context).parentChoosePackage,
                backgroundColor: selected
                    ? ColorManager.secondaryColor
                    : ColorManager.mainColor14,
                textColor: selected ? ColorManager.mainColor14 : null,
                onPressed: () =>
                    context.read<ParentAddChildCubit>().selectPackage(item),
              );
            },
          ),
      ],
    );
  }
}
