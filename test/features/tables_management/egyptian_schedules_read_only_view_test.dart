import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/add_new_topic_button.dart';
import 'package:bnan_app/core/shared_widget/attachment_preview/network_attachment_preview.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_model.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_reference_model.dart';
import 'package:bnan_app/features/tables_management/data/models/egyptian_schedule_classroom_model.dart';
import 'package:bnan_app/features/tables_management/data/models/responses/egyptian_schedules_response_model.dart';
import 'package:bnan_app/features/tables_management/data/repo/table_management_repo.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_cubit.dart';
import 'package:bnan_app/features/tables_management/presentation/manager/get_egyptian_schedules_cubit/get_egyptian_schedules_state.dart';
import 'package:bnan_app/features/tables_management/presentation/views/egyptian_schedules_read_only_view.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_card_section.dart';
import 'package:bnan_app/features/tables_management/presentation/views/widgets/table_schedules_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('read-only renders data without management actions', (
    tester,
  ) async {
    final repo = _QueueRepo([Right(_success())]);
    final cubit = GetEgyptianSchedulesCubit(repo);
    await cubit.getMyEgyptianSchedule();

    await tester.pumpWidget(_app(cubit, const EgyptianSchedulesReadOnlyView()));

    expect(find.text('Grade 1 - A'), findsOneWidget);
    expect(find.textContaining('Grade 1'), findsWidgets);
    expect(find.textContaining('Egyptian'), findsOneWidget);
    expect(
      tester
          .widget<NetworkAttachmentPreview>(
            find.byType(NetworkAttachmentPreview),
          )
          .attachmentUrl,
      'https://api.example.com/schedule.jpg',
    );
    expect(find.byType(AddNewTopicButton), findsNothing);
    expect(
      tester.widget<TableCardSection>(find.byType(TableCardSection)).onDelete,
      isNull,
    );
    expect(repo.unexpectedCalls, isEmpty);
  });

  testWidgets('empty response uses the existing no-data state', (tester) async {
    final cubit = GetEgyptianSchedulesCubit(_QueueRepo([Right(_empty())]));
    await cubit.getMyEgyptianSchedule();

    await tester.pumpWidget(_app(cubit, const EgyptianSchedulesReadOnlyView()));

    expect(cubit.state, isA<GetEgyptianSchedulesEmpty>());
    expect(find.byType(NoDataWidget), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(NoDataWidget),
        matching: find.byType(Center),
      ),
      findsWidgets,
    );
  });

  testWidgets('failure retry repeats only the read operation', (tester) async {
    final repo = _QueueRepo([
      Left(Failure(message: 'Unavailable')),
      Right(_empty()),
    ]);
    final cubit = GetEgyptianSchedulesCubit(repo);
    await cubit.getMyEgyptianSchedule();
    await tester.pumpWidget(_app(cubit, const EgyptianSchedulesReadOnlyView()));

    expect(find.text('Unavailable'), findsOneWidget);
    await tester.tap(find.byKey(const Key('egyptianSchedulesRetry')));
    await tester.pump();

    expect(repo.myScheduleCalls, 2);
    expect(repo.unexpectedCalls, isEmpty);
    expect(find.byType(NoDataWidget), findsOneWidget);
  });

  testWidgets('management content keeps delete enabled by default', (
    tester,
  ) async {
    final cubit = GetEgyptianSchedulesCubit(_QueueRepo([Right(_success())]));
    await cubit.getMyEgyptianSchedule();
    await tester.pumpWidget(_app(cubit, const TableSchedulesContent()));

    expect(
      tester.widget<TableCardSection>(find.byType(TableCardSection)).onDelete,
      isNotNull,
    );
  });
}

Widget _app(GetEgyptianSchedulesCubit cubit, Widget child) {
  return BlocProvider.value(
    value: cubit,
    child: MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

EgyptianSchedulesResponseModel _success() =>
    EgyptianSchedulesResponseModel(schedules: [_schedule()]);

EgyptianSchedulesResponseModel _empty() =>
    const EgyptianSchedulesResponseModel();

EgyptianScheduleModel _schedule() => const EgyptianScheduleModel(
  id: 'scheduleId',
  classroom: EgyptianScheduleClassroomModel(
    id: 'classroomId',
    name: 'Grade 1 - A',
  ),
  grade: EgyptianScheduleReferenceModel(id: 'gradeId', name: 'Grade 1'),
  curriculum: EgyptianScheduleReferenceModel(
    id: 'curriculumId',
    name: 'Egyptian',
  ),
  image: 'https://api.example.com/schedule.jpg',
);

class _QueueRepo implements TableManagementRepo {
  _QueueRepo(this.results);

  final List<Either<Failure, EgyptianSchedulesResponseModel>> results;
  final List<Symbol> unexpectedCalls = [];
  int myScheduleCalls = 0;

  @override
  Future<Either<Failure, EgyptianSchedulesResponseModel>>
  getMyEgyptianSchedule({String? studentId}) async {
    final index = myScheduleCalls.clamp(0, results.length - 1);
    myScheduleCalls++;
    return results[index];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    unexpectedCalls.add(invocation.memberName);
    return super.noSuchMethod(invocation);
  }
}
