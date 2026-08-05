import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_table_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';

class ScheduleBody extends StatelessWidget {
  const ScheduleBody({super.key, this.isGulfStudent = false});

  final bool isGulfStudent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomAppbar(
          headerText: S.of(context).studySchedule,
          iconNeeded: false,
        ),
        Expanded(
          child: isGulfStudent
              ? BlocProvider(
                  create: (_) => getIt<GulfScheduleCubit>()..load(),
                  child: const LessonsManagementBody(readOnly: true),
                )
              : ListView(
                  padding: const EdgeInsetsDirectional.all(16),
                  children: const [ScheduleTableCard()],
                ),
        ),
      ],
    );
  }
}
