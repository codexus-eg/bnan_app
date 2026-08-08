import 'package:bnan_app/features/weekly_evaluations/data/models/elapsed_evaluation_weeks_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/upsert_evaluation_request_model.dart';
import 'package:bnan_app/features/weekly_evaluations/data/models/evaluation_value_model.dart';
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

  test('bonus uses correct key and never sends legacy names', () {
    const request = UpsertEvaluationRequestModel(
      student: 's',
      classroom: 'c',
      subject: 'x',
      week: 2,
      attendance: 'present',
      participation: 'excellent',
      homework: 'good',
      behavior: 'good',
      bonus: 4,
    );
    final json = request.toJson();
    expect(json['bonus'], 4);
    expect(json, isNot(contains('bouns')));
    expect(json, isNot(contains('manualBonusPoints')));
  });

  test('bonus parsing prioritizes bonus, falls back to bouns, then zero', () {
    expect(EvaluationValueModel.fromJson({'bonus': 4, 'bouns': 2}).bonus, 4);
    expect(
      EvaluationValueModel.fromJson({'bonus': null, 'bouns': '3'}).bonus,
      3,
    );
    expect(EvaluationValueModel.fromJson({'bonus': 2.0}).bonus, 2);
    expect(EvaluationValueModel.fromJson(const {}).bonus, 0);
  });

  test('complete response parses student subject and evaluation ids', () {
    final response = WeeklyEvaluationsResponseModel.fromJson({
      'success': true,
      'results': 1,
      'data': {
        'classroom': {'_id': 'classroom', 'name': 'Class A'},
        'week': 3,
        'weekStart': '2026-08-01',
        'students': [
          {
            'studentId': 'student',
            'fullName': 'Student Name',
            'subjects': [
              {
                '_id': 'subject',
                'name': 'Math',
                'status': 'evaluated',
                'evaluation': {
                  '_id': 'evaluation',
                  'attendance': 'present',
                  'participation': 'good',
                  'homework': 'excellent',
                  'behavior': 'very_good',
                  'notes': '',
                },
              },
            ],
          },
        ],
      },
    });

    final data = response.data;
    final student = data.students.single;
    final subject = student.subjects.single;
    expect(data.classroomId, 'classroom');
    expect(data.week, 3);
    expect(student.id, 'student');
    expect(subject.id, 'subject');
    expect(subject.evaluation?.id, 'evaluation');
    expect(subject.evaluation?.notes, isEmpty);
  });

  test('single-student response shape and missing scores parse safely', () {
    final response = WeeklyEvaluationsResponseModel.fromJson({
      'success': true,
      'data': {
        'week': '2',
        'student': {'_id': 'student', 'name': 'Student'},
        'subjects': [
          {
            'id': 'subject',
            'name': 'Science',
            'evaluation': {'attendance': null, 'notes': null},
          },
        ],
      },
    });

    final subject = response.data.students.single.subjects.single;
    expect(response.data.week, 2);
    expect(subject.isEvaluated, isTrue);
    expect(subject.evaluation?.attendance, isEmpty);
    expect(subject.evaluation?.participation, isEmpty);
    expect(subject.evaluation?.notes, isEmpty);
  });
}
