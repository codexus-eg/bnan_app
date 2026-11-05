import 'package:bnan_app/features/teacher_home/data/repo/teacher_session_statistics_repo.dart';
import 'package:bnan_app/features/teacher_home/presentation/manager/teacher_session_statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherSessionStatisticsCubit
    extends Cubit<TeacherSessionStatisticsState> {
  TeacherSessionStatisticsCubit(this._repo)
      : super(const TeacherSessionStatisticsInitial());

  final TeacherSessionStatisticsRepo _repo;

  Future<void> load({String? from, String? to}) async {
    emit(const TeacherSessionStatisticsLoading());
    final result = await _repo.getSessionStatistics(from: from, to: to);
    result.fold(
      (failure) => emit(TeacherSessionStatisticsFailure(failure.message)),
      (statistics) => emit(TeacherSessionStatisticsSuccess(statistics)),
    );
  }
}
