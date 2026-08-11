import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/policies/parent_package_policy.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenewalPackageStep extends StatelessWidget {
  const RenewalPackageStep({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ParentSubscriptionRenewalCubit>().state;
    return SubscriptionGrid(
      curriculumId: state.args.curriculumId,
      curriculumName: '',
      isSliver: false,
      registrationMode: state.args.registrationMode,
      packageFilter: (item) =>
          ParentPackagePolicy.isVisible(
            item,
            registrationMode: state.args.registrationMode,
          ) &&
          item.curriculum == state.args.curriculumId,
      bottomWidget: (_, item) {
        final selected = state.package?.id == item.id;
        return CustomAppButton(
          height: 38,
          text: selected
              ? S.of(context).parentPackageSelected
              : S.of(context).parentChoosePackage,
          backgroundColor: selected
              ? ColorManager.secondaryColor
              : ColorManager.mainColor14,
          textColor: selected ? ColorManager.mainColor14 : null,
          onPressed: () => context
              .read<ParentSubscriptionRenewalCubit>()
              .selectPackage(item),
        );
      },
    );
  }
}
