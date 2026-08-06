import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_state.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_child_selector.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_content.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_failure.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleBody extends StatelessWidget {
  const ParentScheduleBody({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      CustomAppbar(headerText: S.of(context).parentSchedule),
      Expanded(
        child: BlocBuilder<GetParentChildrenCubit, GetParentChildrenState>(
          builder: (context, state) {
            if (state is GetParentChildrenFailure) {
              return TableSchedulesFailure(
                message: state.errorMessage,
                onRetry: context
                    .read<GetParentChildrenCubit>()
                    .getParentChildren,
              );
            }
            if (state is! GetParentChildrenSuccess) {
              return const AppSkeletonizer(
                isLoading: true,
                child: NoDataWidget(),
              );
            }
            final child = state.selectedChild;
            if (child == null) return const NoDataWidget();
            return Column(
              children: [
                ParentScheduleChildSelector(state: state),
                Expanded(child: ParentScheduleContent(child: child)),
              ],
            );
          },
        ),
      ),
    ],
  );
}
