import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_details_widget_background.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_cubit.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_state.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_statistics_metric_box.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherStatisticsCard extends StatelessWidget {
  const TeacherStatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherSessionStatisticsCubit,
        TeacherSessionStatisticsState>(
      builder: (context, state) {
        final isLoading = state is TeacherSessionStatisticsLoading;
        final stats = state is TeacherSessionStatisticsSuccess
            ? state.statistics
            : const TeacherSessionStatisticsModel();

        return CustomDetailsWidgetBackground(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).teachingSummary,
                style: StylesManager.styleBold16(
                  context,
                ).copyWith(color: ColorManager.mainColor14),
              ),
              const SizedBox(height: 12),
              AppSkeletonizer(
                isLoading: isLoading,
                child: Row(
                  children: [
                    Expanded(
                      child: TeacherStatisticsMetricBox(
                        title: S.of(context).totalHours,
                        value: _format(stats.totalHours),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TeacherStatisticsMetricBox(
                        title: S.of(context).totalSessions,
                        value: _format(stats.totalSessions),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _format(num v) => v is int || v == v.roundToDouble()
      ? v.toInt().toString()
      : v.toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
}
