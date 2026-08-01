import 'package:bnan_app/features/plans/presentation/models/plan_day_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/models/plan_subject_ui_model.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_day_row.dart';
import 'package:bnan_app/features/plans/presentation/views/widgets/weekly_plans/weekly_plan_header.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const longDay = 'Very long weekly planning day name';
const longSubject = 'Advanced mathematics and analytical thinking';
const longLesson = 'A detailed lesson that wraps across several visible lines';
const longHomework = 'Complete every exercise and explain each answer clearly';

class WeeklyPlanTextFixture extends StatelessWidget {
  const WeeklyPlanTextFixture({super.key, required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context) {
    const subject = PlanSubjectUiModel(
      subjectName: longSubject,
      lesson: longLesson,
      homework: longHomework,
    );
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(2)),
        child: child!,
      ),
      home: const Scaffold(
        body: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                WeeklyPlanHeader(
                  subjectNames: [longSubject],
                  dayWidth: 63,
                  subjectWidth: 125,
                ),
                WeeklyPlanDayRow(
                  day: PlanDayUiModel(dayName: longDay, subjects: [subject]),
                  subjectNames: [longSubject],
                  dayWidth: 63,
                  subjectWidth: 125,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
