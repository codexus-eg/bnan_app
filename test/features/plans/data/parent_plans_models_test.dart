import 'package:bnan_app/features/plans/data/models/parent_children_plans_response_model.dart';
import 'package:bnan_app/features/plans/data/models/parent_children_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent responses accept nullable classroom avatar and empty plans', () {
    final children = ParentChildrenResponseModel.fromJson({
      'status': 'success',
      'data': [
        {'id': 'child', 'fullName': 'Child', 'classroom': null},
      ],
    });
    final plans = ParentChildrenPlansResponseModel.fromJson({
      'success': true,
      'results': 1,
      'data': [
        {
          'student': {'id': 'child', 'fullName': 'Child', 'avatar': null},
          'week': 1,
          'classrooms': [],
          'subjects': [
            {'id': 'math', 'name': 'Math', 'plans': []},
          ],
        },
      ],
    });

    expect(children.data.single.classroom, isNull);
    expect(plans.data.single.student.avatar, isNull);
    expect(plans.data.single.subjects.single.name, 'Math');
    expect(plans.data.single.subjects.single.plans, isEmpty);
  });
}
