import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_subject_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_classroom_option.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/manager/weekly_evaluations_cubit.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/mappers/weekly_evaluation_ui_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_dialog_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/models/evaluation_editor_context.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/policies/weekly_evaluations_access_policy.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/dialogs/weekly_evaluation_dialog.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_card.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_subject_actions.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyEvaluationsStudents extends StatelessWidget {
  const WeeklyEvaluationsStudents({
    super.key,
    required this.policy,
    required this.response,
    required this.cubit,
  });
  final WeeklyEvaluationsAccessPolicy policy;
  final WeeklyEvaluationsResponseModel response;
  final WeeklyEvaluationsCubit cubit;

  @override
  Widget build(BuildContext context) {
    final data = response.data;
    return Column(
      children: List.generate(data.students.length, (index) {
        final student = data.students[index];
        final ui = mapWeeklyEvaluationToUi(
          context,
          student,
          classroomName: data.classroomName,
          week: cubit.selectedWeek ?? data.week,
          title: S.of(context).weeklyEvaluationStudentTitle(student.fullName),
          index: index,
        );
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 16),
          child: WeeklyEvaluationCard(
            evaluation: ui,
            headerAction: policy.canEdit
                ? WeeklyEvaluationSubjectActions(
                    subjects: student.subjects,
                    onPressed: (subject) =>
                        _showEdit(context, data, student, subject),
                  )
                : null,
          ),
        );
      }),
    );
  }

  void showAdd(BuildContext context, List<PlanClassroomOption> classrooms) {
    final classroom = cubit.selectedClassroom;
    final week = cubit.selectedWeek;
    if (classroom == null || week == null) return;
    _showDialog(
      context,
      EvaluationDialogContext.add(week: week, classrooms: classrooms),
    );
  }

  void _showEdit(
    BuildContext context,
    WeeklyEvaluationsDataModel data,
    WeeklyEvaluationStudentModel student,
    EvaluationSubjectModel subject,
  ) {
    final classroom = cubit.selectedClassroom;
    final week = cubit.selectedWeek;
    if (classroom == null || week == null) return;
    _showDialog(
      context,
      EvaluationDialogContext.edit(
        EvaluationEditorContext(
          studentId: student.id,
          studentName: student.fullName,
          classroomId: classroom.id,
          classroomName: data.classroomName.isEmpty
              ? classroom.name
              : data.classroomName,
          week: week,
          subject: subject,
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, EvaluationDialogContext data) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: WeeklyEvaluationDialog(data: data),
      ),
    );
  }
}
