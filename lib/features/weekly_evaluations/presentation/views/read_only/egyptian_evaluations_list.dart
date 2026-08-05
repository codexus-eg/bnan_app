import 'package:bnan_app/features/weekly_evaluations/data/read_only/models/me_weekly_evaluations_data_model.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/read_only/read_only_evaluation_table_mapper.dart';
import 'package:bnan_app/features/weekly_evaluations/presentation/views/widgets/weekly_evaluation_table.dart';
import 'package:flutter/material.dart';

class EgyptianEvaluationsList extends StatelessWidget {
  const EgyptianEvaluationsList({super.key, required this.data});
  final MeWeeklyEvaluationsDataModel data;

  @override
  Widget build(BuildContext context) => ListView(
    key: const Key('egyptianEvaluationsLazyList'),
    children: [
      WeeklyEvaluationTable(
        key: const Key('readOnlyEvaluationTable'),
        subjects: mapEgyptianReadOnlyRows(context, data),
      ),
    ],
  );
}
