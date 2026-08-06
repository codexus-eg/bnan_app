import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/parent_home/presentation/manager/get_parent_children/get_parent_children_cubit.dart';
import 'package:bnan_app/features/parent_home/presentation/views/widgets/parent_schedule/parent_schedule_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentScheduleView extends StatelessWidget {
  const ParentScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetParentChildrenCubit>()..getParentChildren(),
      child: const Scaffold(body: ParentScheduleBody()),
    );
  }
}
