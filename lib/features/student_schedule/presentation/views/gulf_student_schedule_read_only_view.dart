import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/lessons_management/data/repo/gulf_schedule_repo.dart';
import 'package:bnan_app/features/lessons_management/presentation/manager/gulf_schedule_cubit.dart';
import 'package:bnan_app/features/lessons_management/presentation/views/widgets/lessons_management_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GulfStudentScheduleReadOnlyView extends StatelessWidget {
  const GulfStudentScheduleReadOnlyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          GulfScheduleCubit(getIt<GulfScheduleRepo>(), canManage: false)
            ..load(),
      child: Scaffold(
        appBar: CustomAppbar(headerText: S.of(context).studySchedule),
        body: const LessonsManagementBody(readOnly: true),
      ),
    );
  }
}
