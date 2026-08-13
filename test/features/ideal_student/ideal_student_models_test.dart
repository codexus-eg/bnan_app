import 'package:bnan_app/features/ideal_student/data/models/ideal_student_ranking_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses complete response and flexible numeric values', () {
    final response = IdealStudentRankingResponse.fromJson({
      'data': {
        'classroom': {'id': 'c1', 'name': 'Class A'},
        'period': {
          'weekStart': '2026-08-01T00:00:00.000Z',
          'weekEnd': '2026-08-08T00:00:00.000Z',
        },
        'status': 'final',
        'dataQuality': {'isComplete': true, 'reasons': []},
        'idealStudent': _item(rank: '1', weekly: '92', bonus: 4.0),
        'ranking': [_item(rank: 1.0, weekly: 92, bonus: '4')],
        'pagination': {'page': '1', 'limit': 20.0, 'total': '30', 'pages': 2},
      },
    });
    expect(response.idealStudent?.name, 'Student');
    expect(response.idealStudent?.weeklyPoints, 92);
    expect(response.idealStudent?.bonusPoints, 4);
    expect(response.idealStudent?.gradeLabel, 'Class A');
    expect(response.pagination.total, 30);
    expect(response.period.weekStart, DateTime.utc(2026, 8, 1));
  });

  test('null ideal, empty ranking and missing fields parse safely', () {
    final response = IdealStudentRankingResponse.fromJson({
      'data': {
        'status': 'insufficient_data',
        'idealStudent': null,
        'ranking': [],
      },
    });
    expect(response.idealStudent, isNull);
    expect(response.ranking, isEmpty);
    expect(response.pagination.page, 1);
    expect(response.dataQuality.reasons, isEmpty);
  });

  test('flat student identity and legacy bonus fields remain compatible', () {
    final response = IdealStudentRankingResponse.fromJson({
      'data': {
        'status': 'final',
        'ranking': [
          {
            'studentId': 'student-flat',
            'fullName': 'Flat Student',
            'weeklyPoints': 70,
            'bouns': 3,
            'rank': 1,
          },
        ],
      },
    });

    expect(response.ranking.single.studentId, 'student-flat');
    expect(response.ranking.single.name, 'Flat Student');
    expect(response.ranking.single.bonusPoints, 3);
  });
}

Map<String, dynamic> _item({Object? rank, Object? weekly, Object? bonus}) => {
  'rank': rank,
  'student': {'id': 's1', 'userId': 'u1', 'fullName': 'Student'},
  'weeklyPoints': weekly,
  'automatedPoints': '88',
  'bonusPoints': bonus,
  'isQualifiedForIdealStudent': true,
  'opportunityCoverage': '100',
};
