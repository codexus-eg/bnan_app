import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/empty_state.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_model.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_state.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TableSchedulesContent extends StatelessWidget {
  const TableSchedulesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEgyptianSchedulesCubit, GetEgyptianSchedulesState>(
      builder: (context, state) {
        if (state is GetEgyptianSchedulesFailure) {
          return EmptyStateWidget(
            image: ImageManager.noData,
            title: state.message,
          );
        }

        final isLoading =
            state is GetEgyptianSchedulesLoading ||
            state is GetEgyptianSchedulesInitial;
        final schedules = state is GetEgyptianSchedulesSuccess
            ? state.response.schedules
            : EgyptianScheduleModel.placeholders;

        if (!isLoading && schedules.isEmpty) return const NoDataWidget();

        return AppSkeletonizer(
          isLoading: isLoading,
          child: TableSchedulesList(
            schedules: schedules,
            enableDelete: !isLoading,
          ),
        );
      },
    );
  }
}
