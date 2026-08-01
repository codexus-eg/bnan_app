import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluation_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_dummy_data.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/weekly_evaluation_ui_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_classroom_filter.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_failure.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_header_actions.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_list.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluations_skeleton.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class WeeklyEvaluationsBody extends StatefulWidget {
  const WeeklyEvaluationsBody({
    super.key,
    required this.policy,
    this.evaluations = weeklyEvaluationsDummyData,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  final WeeklyEvaluationsAccessPolicy policy;
  final List<WeeklyEvaluationModel> evaluations;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<WeeklyEvaluationsBody> createState() => _WeeklyEvaluationsBodyState();
}

class _WeeklyEvaluationsBodyState extends State<WeeklyEvaluationsBody> {
  String? _selectedClassroom;

  List<String> get _classrooms {
    return widget.evaluations
        .map((item) => item.classLabel)
        .where((item) => item.trim().isNotEmpty)
        .toSet()
        .toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _selectInitialClassroom();
  }

  @override
  void didUpdateWidget(covariant WeeklyEvaluationsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_classrooms.contains(_selectedClassroom)) _selectInitialClassroom();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
        children: [
          WeeklyEvaluationsSkeleton(
            showActions: widget.policy.canAdd,
            showFilter: widget.policy.canFilterByClassroom,
          ),
        ],
      );
    }
    final evaluations = _visibleEvaluations;
    final s = S.of(context);
    final uiEvaluations = List.generate(evaluations.length, (index) {
      final evaluation = evaluations[index];
      final title = widget.policy.isStudent
          ? s.weeklyEvaluation
          : '${s.weeklyEvaluation} - ${evaluation.studentName}';
      return mapWeeklyEvaluationToUi(s, evaluation, title: title, index: index);
    });
    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
      children: [
        if (widget.policy.canAdd) ...[
          WeeklyEvaluationsHeaderActions(onAddPressed: () => _showForm()),
          const SizedBox(height: 16),
        ],
        if (widget.policy.canFilterByClassroom) ...[
          WeeklyEvaluationsClassroomFilter(
            classrooms: _classrooms,
            selectedClassroom: _selectedClassroom,
            onChanged: (value) => setState(() => _selectedClassroom = value),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.errorMessage != null)
          WeeklyEvaluationsFailure(
            message: widget.errorMessage!,
            onRetry: widget.onRetry,
          )
        else if (uiEvaluations.isEmpty)
          NoDataWidget(title: s.noDataAvailable)
        else
          WeeklyEvaluationsList(
            evaluations: uiEvaluations,
            showEditAction: widget.policy.canEdit,
            onEditPressed: (index) => _showForm(evaluations[index]),
          ),
      ],
    );
  }

  List<WeeklyEvaluationModel> get _visibleEvaluations {
    Iterable<WeeklyEvaluationModel> items = widget.evaluations;
    if (widget.policy.canFilterByClassroom && _selectedClassroom != null) {
      items = items.where((item) => item.classLabel == _selectedClassroom);
    }
    if (widget.policy.isStudent) return items.take(1).toList(growable: false);
    return items.toList(growable: false);
  }

  void _selectInitialClassroom() {
    _selectedClassroom =
        widget.policy.canFilterByClassroom && _classrooms.isNotEmpty
        ? _classrooms.first
        : null;
  }

  Future<void> _showForm([WeeklyEvaluationModel? evaluation]) {
    return showDialog<void>(
      context: context,
      builder: (_) => WeeklyEvaluationDialog(evaluation: evaluation),
    );
  }
}
