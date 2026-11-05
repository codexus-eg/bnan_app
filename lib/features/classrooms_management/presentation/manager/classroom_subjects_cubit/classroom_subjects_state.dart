import 'package:bnan_app/features/classrooms_management/data/models/classroom_subjects_response_model.dart';

sealed class ClassroomSubjectsState {
  const ClassroomSubjectsState();
}

final class ClassroomSubjectsInitial extends ClassroomSubjectsState {
  const ClassroomSubjectsInitial();
}

final class ClassroomSubjectsLoading extends ClassroomSubjectsState {
  const ClassroomSubjectsLoading();
}

final class ClassroomSubjectsLoaded extends ClassroomSubjectsState {
  const ClassroomSubjectsLoaded({
    required this.data,
    this.actionLoading = false,
    this.feedbackMessage,
    this.isError = false,
  });

  final ClassroomSubjectsResponseModel data;
  final bool actionLoading;
  final String? feedbackMessage;
  final bool isError;

  ClassroomSubjectsLoaded copyWith({
    ClassroomSubjectsResponseModel? data,
    bool? actionLoading,
    String? feedbackMessage,
    bool? isError,
  }) => ClassroomSubjectsLoaded(
    data: data ?? this.data,
    actionLoading: actionLoading ?? this.actionLoading,
    feedbackMessage: feedbackMessage,
    isError: isError ?? false,
  );
}

final class ClassroomSubjectsFailure extends ClassroomSubjectsState {
  const ClassroomSubjectsFailure(this.message);
  final String message;
}
