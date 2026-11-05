import 'package:bnan_app/features/teacher_home/data/models/teacher_session_statistics_model.dart';
import 'package:equatable/equatable.dart';

sealed class TeacherSessionStatisticsState extends Equatable {
  const TeacherSessionStatisticsState();
  @override
  List<Object?> get props => [];
}

class TeacherSessionStatisticsInitial extends TeacherSessionStatisticsState {
  const TeacherSessionStatisticsInitial();
}

class TeacherSessionStatisticsLoading extends TeacherSessionStatisticsState {
  const TeacherSessionStatisticsLoading();
}

class TeacherSessionStatisticsSuccess extends TeacherSessionStatisticsState {
  const TeacherSessionStatisticsSuccess(this.statistics);
  final TeacherSessionStatisticsModel statistics;
  @override
  List<Object?> get props => [statistics];
}

class TeacherSessionStatisticsFailure extends TeacherSessionStatisticsState {
  const TeacherSessionStatisticsFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
