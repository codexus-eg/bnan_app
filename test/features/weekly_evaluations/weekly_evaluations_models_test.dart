import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/weekly_evaluations_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('elapsed weeks builds range and selects valid current week', () {
    final response = ElapsedEvaluationWeeksModel.fromJson({
      'success': true,
      'data': {
        'classroom': {'id': 'c1', 'name': 'Class A'},
        'startDate': '2026-07-25',
        'weeksCount': 3,
        'completedWeeks': 2,
        'currentWeek': 2,
      },
    });

    expect(response.data.weeks, [1, 2, 3]);
    expect(response.data.initialWeek, 2);
    expect(response.data.classroomId, 'c1');
  });

  test('invalid current week falls back to last available week', () {
    const data = ElapsedEvaluationWeeksData(weeksCount: 2, currentWeek: 8);
    expect(data.initialWeek, 2);
    expect(const ElapsedEvaluationWeeksData().initialWeek, isNull);
  });

  test('null evaluation and missing optional values parse safely', () {
    final response = WeeklyEvaluationsResponseModel.fromJson({
      'success': true,
      'data': {
        'week': 2,
        'students': [
          {
            'id': 'student',
            'fullName': 'Student',
            'subjects': [
              {
                'id': 'subject',
                'name': 'Physics',
                'status': 'not_evaluated',
                'evaluation': null,
              },
            ],
          },
        ],
      },
    });

    final subject = response.data.students.single.subjects.single;
    expect(subject.evaluation, isNull);
    expect(subject.isEvaluated, isFalse);
  });

  test('upsert body has week and behavior but never weekStart or id', () {
    const request = UpsertEvaluationRequestModel(
      student: 's',
      classroom: 'c',
      subject: 'x',
      week: 2,
      attendance: 'present',
      participation: 'excellent',
      homework: 'good',
      behavior: 'very_good',
    );
    final json = request.toJson();

    expect(json['week'], 2);
    expect(json['behavior'], 'very_good');
    expect(json, isNot(contains('weekStart')));
    expect(json, isNot(contains('evaluationId')));
  });

  test('upsert preserves exact backend evaluation values', () {
    const request = UpsertEvaluationRequestModel(
      student: 's',
      classroom: 'c',
      subject: 'x',
      week: 2,
      attendance: 'excused',
      participation: 'very_good',
      homework: '-',
      behavior: 'acceptable',
    );

    expect(request.toJson(), containsPair('attendance', 'excused'));
    expect(request.toJson(), containsPair('participation', 'very_good'));
    expect(request.toJson(), containsPair('homework', '-'));
    expect(request.toJson(), containsPair('behavior', 'acceptable'));
  });
}
