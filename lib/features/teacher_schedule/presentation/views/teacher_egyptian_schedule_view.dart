import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/student_schedule/presentation/manager/egyptian_schedule_cubit.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/egyptian_digital_schedule/egyptian_schedule_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherEgyptianScheduleView extends StatelessWidget {
  const TeacherEgyptianScheduleView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => EgyptianScheduleCubit(getIt<TableManagementRepo>())..load(),
    child: Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).schedule),
      body: const EgyptianScheduleBody(forStudent: false),
    ),
  );
}
