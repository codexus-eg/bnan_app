import 'dart:io';

import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/create_egyptian_schedule_cubit/create_egyptian_schedule_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEgyptianScheduleCubit extends Cubit<CreateEgyptianScheduleState> {
  CreateEgyptianScheduleCubit(this.repo)
    : super(CreateEgyptianScheduleInitial());

  final TableManagementRepo repo;

  Future<void> createEgyptianSchedule({
    required String classroomId,
    required File scheduleImage,
  }) async {
    emit(CreateEgyptianScheduleLoading());

    final result = await repo.createEgyptianSchedule(
      classroomId: classroomId,
      scheduleImage: scheduleImage,
    );

    result.fold(
      (failure) => emit(CreateEgyptianScheduleFailure(failure.message)),
      (response) => emit(CreateEgyptianScheduleSuccess(response)),
    );
  }
}
