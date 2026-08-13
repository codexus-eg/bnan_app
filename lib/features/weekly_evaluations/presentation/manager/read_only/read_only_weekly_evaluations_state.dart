import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/parent_evaluation_child_model.dart';

enum ReadOnlyEvaluationsRole { student, parent }

enum ReadOnlyEvaluationsStatus { initial, loading, success, empty, failure }

class ReadOnlyWeeklyEvaluationsState {
  const ReadOnlyWeeklyEvaluationsState({
    this.role,
    this.status = ReadOnlyEvaluationsStatus.initial,
    this.isLoading = false,
    this.children = const [],
    this.selectedChildId,
    this.selectedWeek,
    this.maxAvailableWeek,
    this.data,
    this.failureMessage,
    this.hasLoadedChildren = false,
    this.isChangingChild = false,
    this.isChangingWeek = false,
    this.hasNoClassroom = false,
  });

  final ReadOnlyEvaluationsRole? role;
  final ReadOnlyEvaluationsStatus status;
  final bool isLoading, hasLoadedChildren, isChangingChild, isChangingWeek;
  final bool hasNoClassroom;
  final List<ParentEvaluationChildModel> children;
  final String? selectedChildId, failureMessage;
  final int? selectedWeek, maxAvailableWeek;
  final MeWeeklyEvaluationsDataModel? data;

  ReadOnlyWeeklyEvaluationsState copyWith({
    ReadOnlyEvaluationsRole? role,
    ReadOnlyEvaluationsStatus? status,
    bool? isLoading,
    List<ParentEvaluationChildModel>? children,
    Object? selectedChildId = _unset,
    Object? selectedWeek = _unset,
    Object? maxAvailableWeek = _unset,
    Object? data = _unset,
    Object? failureMessage = _unset,
    bool? hasLoadedChildren,
    bool? isChangingChild,
    bool? isChangingWeek,
    bool? hasNoClassroom,
  }) => ReadOnlyWeeklyEvaluationsState(
    role: role ?? this.role,
    status: status ?? this.status,
    isLoading: isLoading ?? this.isLoading,
    children: children ?? this.children,
    selectedChildId: selectedChildId == _unset
        ? this.selectedChildId
        : selectedChildId as String?,
    selectedWeek: selectedWeek == _unset
        ? this.selectedWeek
        : selectedWeek as int?,
    maxAvailableWeek: maxAvailableWeek == _unset
        ? this.maxAvailableWeek
        : maxAvailableWeek as int?,
    data: data == _unset ? this.data : data as MeWeeklyEvaluationsDataModel?,
    failureMessage: failureMessage == _unset
        ? this.failureMessage
        : failureMessage as String?,
    hasLoadedChildren: hasLoadedChildren ?? this.hasLoadedChildren,
    isChangingChild: isChangingChild ?? this.isChangingChild,
    isChangingWeek: isChangingWeek ?? this.isChangingWeek,
    hasNoClassroom: hasNoClassroom ?? this.hasNoClassroom,
  );
}

const _unset = Object();
