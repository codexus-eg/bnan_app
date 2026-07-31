import 'package:bnan_app/features/plans/data/models/create_daily_plan_request_model.dart';
import 'package:bnan_app/features/plans/data/models/create_plan_response_model.dart';
import 'package:bnan_app/features/plans/data/models/elapsed_weeks_response_model.dart';
import 'package:bnan_app/features/plans/data/models/term_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/weekly_plans_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('daily request owns the day type', () {
    const request = CreateDailyPlanRequestModel(
      day: '2026-07-29',
      sessionContent: 'content',
      sessionAssignment: 'assignment',
    );

    expect(request.toJson(), {
      'type': 'day',
      'day': '2026-07-29',
      'sessionContent': 'content',
      'sessionAssignment': 'assignment',
    });
  });

  test('create response accepts id and _id safely', () {
    final model = CreatePlanResponseModel.fromJson({
      'success': true,
      'data': {
        '_id': 'plan-id',
        'subject': {'_id': 'subject-id', 'name': 'English'},
        'teacher': {
          '_id': 'teacher-id',
          'user': {'id': 'user-id', 'fullName': 'Salma'},
        },
      },
    });

    expect(model.data.id, 'plan-id');
    expect(model.data.subject.id, 'subject-id');
    expect(model.data.teacher.user.id, 'user-id');
  });

  test('weekly, term and elapsed responses parse nested data', () {
    final weekly = WeeklyPlansResponseModel.fromJson({
      'results': '1',
      'data': {
        'week': 2,
        'subjects': [
          {
            'id': 'subject',
            'plans': [
              {'day': 'Wednesday', 'sessionContent': 'lesson'},
            ],
          },
        ],
      },
    });
    final term = TermPlansResponseModel.fromJson({
      'data': {
        'subjects': [
          {
            'plans': [
              {'attachment': 'https://example.com/file.png'},
            ],
          },
        ],
      },
    });
    final elapsed = ElapsedWeeksResponseModel.fromJson({
      'data': {'weeksCount': '4', 'currentWeek': 2},
    });

    expect(weekly.data.subjects.single.plans.single.day, 'Wednesday');
    expect(term.data.subjects.single.plans.single.attachment, isNotEmpty);
    expect(elapsed.data.weeksCount, 4);
    expect(ElapsedWeeksResponseModel.fromJson({}).data.startDate, '');
  });
}
