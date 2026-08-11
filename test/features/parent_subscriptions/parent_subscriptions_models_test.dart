import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('multiple subscriptions parse when legacy subscription is null', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1', 'fullName': 'Child'},
          'subscription': null,
          'subscriptions': [
            {
              'id': 'new-1',
              'accessScope': 'single_subject',
              'subject': {'id': 's1', 'name': 'Math'},
            },
            {
              'id': 'new-2',
              'accessScope': 'single_subject',
              'subject': {'id': 's2', 'name': 'Science'},
            },
          ],
        },
      ],
    });
    expect(response.children.single.subscriptions.map((item) => item.id), [
      'new-1',
      'new-2',
    ]);
    expect(response.children.single.subjects.map((item) => item.id), [
      's1',
      's2',
    ]);
  });

  test('legacy subscription is used when subscriptions is null', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1', 'fullName': 'Child'},
          'subscription': {'id': 'legacy'},
          'subscriptions': null,
        },
      ],
    });

    expect(response.children.single.subscriptions.single.id, 'legacy');
  });

  test('hours and numeric strings parse safely', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1'},
          'subscriptions': [
            {
              'id': 'sub',
              'purchasedHours': '10',
              'remainingHours': 3.5,
              'usedHours': '6.5',
            },
          ],
        },
      ],
    });
    final subscription = response.children.single.subscriptions.single;
    expect(subscription.purchasedHours, 10);
    expect(subscription.remainingHours, 3.5);
    expect(subscription.usedHours, 6.5);
  });
}
