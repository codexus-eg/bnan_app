import 'package:bnan_app/features/ideal_teacher/data/models/point_adjustment_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_item_model.dart';
import 'package:bnan_app/features/ideal_teacher/data/models/teacher_ranking_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TeacherRankingResponse mapping', () {
    test('parses full ranking payload correctly', () {
      final json = {
        'classroom': {'id': 'cls_1', 'name': 'Grade 10A'},
        'period': {
          'weekStart': '2026-10-24T21:00:00.000Z',
          'weekEnd': '2026-10-31T21:00:00.000Z',
          'cutoff': '2026-10-27T12:00:00.000Z',
          'timezone': 'Africa/Cairo',
        },
        'scoreVersion': 'v2',
        'status': 'final',
        'idealTeacher': {'id': 't_1', 'fullName': 'Ahmed Mohamed'},
        'ranking': [
          {
            'rank': 1,
            'teacher': {'id': 't_1', 'fullName': 'Ahmed Mohamed'},
            'subjects': ['Math', 'Physics'],
            'weeklyPoints': 88.5,
            'isQualifiedForIdealTeacher': true,
            'dataCoverage': 0.95,
            'components': {
              'attendance': {'points': 20.0, 'maxPoints': 20.0},
              'punctuality': {'points': 18.0, 'maxPoints': 20.0},
              'interaction': {'points': 8.5, 'maxPoints': 10.0},
              'weeklyTasks': {'points': 22.0, 'maxPoints': 25.0},
              'grading': {'points': 20.0, 'maxPoints': 25.0},
            },
          },
          {
            'rank': 2,
            'teacher': {'id': 't_2', 'fullName': 'Sara Ali'},
            'subjects': ['English'],
            'weeklyPoints': null,
            'isQualifiedForIdealTeacher': false,
            'dataCoverage': 0.40,
            'components': {
              'interaction': {'points': 3.0, 'maxPoints': 10.0},
            },
          },
        ],
        'pagination': {'page': 1, 'pages': 2, 'limit': 20, 'total': 25},
      };

      final response = TeacherRankingResponse.fromJson(json);

      expect(response.classroomId, 'cls_1');
      expect(response.classroomName, 'Grade 10A');
      expect(response.status, 'final');
      expect(response.isProvisional, isFalse);
      expect(response.isInsufficientData, isFalse);
      expect(response.hasQualifiedWinner, isTrue);
      expect(response.idealTeacher?.teacherId, 't_1');
      expect(response.idealTeacher?.fullName, 'Ahmed Mohamed');
      expect(response.page, 1);
      expect(response.pages, 2);
      expect(response.ranking.length, 2);

      final top = response.ranking[0];
      expect(top.rank, 1);
      expect(top.teacherId, 't_1');
      expect(top.fullName, 'Ahmed Mohamed');
      expect(top.subjects, ['Math', 'Physics']);
      expect(top.weeklyPoints, 88.5);
      expect(top.manualPoints, 8.5);
      expect(top.isQualifiedForIdealTeacher, isTrue);
      expect(top.dataCoverage, 0.95);
      expect(top.components.attendance.points, 20.0);
      expect(top.components.punctuality.points, 18.0);
      expect(top.components.weeklyTasks.points, 22.0);
      expect(top.components.grading.points, 20.0);

      final second = response.ranking[1];
      expect(second.rank, 2);
      expect(second.teacherId, 't_2');
      expect(second.fullName, 'Sara Ali');
      expect(second.weeklyPoints, isNull);
      expect(second.manualPoints, 3.0);
      expect(second.isQualifiedForIdealTeacher, isFalse);
    });

    test('handles insufficient_data and provisional statuses', () {
      final insufficientJson = {
        'status': 'insufficient_data',
        'idealTeacher': null,
        'ranking': [],
      };
      final provisionalJson = {
        'status': 'provisional',
        'idealTeacher': {'id': 't_9', 'fullName': 'Provisional Winner'},
        'ranking': [],
      };

      final insufficient = TeacherRankingResponse.fromJson(insufficientJson);
      final provisional = TeacherRankingResponse.fromJson(provisionalJson);

      expect(insufficient.isInsufficientData, isTrue);
      expect(insufficient.hasQualifiedWinner, isFalse);

      expect(provisional.isProvisional, isTrue);
      expect(provisional.hasQualifiedWinner, isTrue);
      expect(provisional.idealTeacher?.fullName, 'Provisional Winner');
    });

    test('parses weeklyPoints: 0 as valid number and interaction availability', () {
      final json = {
        'rank': 1,
        'teacher': {'id': 't_0', 'fullName': 'Zero Score Teacher'},
        'weeklyPoints': 0,
        'components': {
          'interaction': {
            'available': false,
            'points': 0,
            'maxPoints': 10,
          },
        },
      };

      final item = TeacherRankingItemModel.fromJson(json);
      expect(item.weeklyPoints, 0);
      expect(item.components.interaction.available, isFalse);
      expect(item.components.interaction.max, 10);
    });
  });

  group('PointAdjustmentModel mapping', () {
    test('parses adjustment fields accurately', () {
      final json = {
        'id': 'adj_123',
        'teacherId': 't_1',
        'awardedBy': {'id': 'sup_1', 'name': 'Supervisor Khalid'},
        'points': 4,
        'category': 'effort',
        'reason': 'متابعة ممتازة وجهد استثنائي',
        'isActive': true,
        'createdAt': '2026-10-26T10:00:00.000Z',
      };

      final adj = PointAdjustmentModel.fromJson(json);

      expect(adj.id, 'adj_123');
      expect(adj.teacherId, 't_1');
      expect(adj.awardedByName, 'Supervisor Khalid');
      expect(adj.points, 4);
      expect(adj.category, 'effort');
      expect(adj.reason, 'متابعة ممتازة وجهد استثنائي');
      expect(adj.isActive, isTrue);
      expect(adj.createdAt?.year, 2026);
    });

    test('parses revoked adjustment (isActive: false)', () {
      final json = {
        'id': 'adj_revoked',
        'teacherId': 't_2',
        'points': 2,
        'category': 'weekly_tasks',
        'reason': 'خطأ في التقييم',
        'isActive': false,
      };

      final adj = PointAdjustmentModel.fromJson(json);

      expect(adj.id, 'adj_revoked');
      expect(adj.isActive, isFalse);
    });
  });
}
