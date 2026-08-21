import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
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

  test('available subscriptions list does not fall back to legacy data', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1'},
          'subscriptions': <Object>[],
          'subscription': {'id': 'stale-legacy'},
        },
      ],
    });

    expect(response.children.single.subscriptions, isEmpty);
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

  test('Gulf registration mode is read from the child sibling field', () {
    final child = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'registrationMode': 'gulf',
          'curriculumId': '6a83284e6067abfc995abb3d',
          'student': {'id': 'student-1'},
          'subscription': {'id': 'legacy'},
          'subscriptions': [
            {'id': 'sub', 'registrationMode': 'egyptian'},
          ],
        },
      ],
    }).children.single;

    expect(child.registrationMode, 'gulf');
    expect(child.curriculumId, '6a83284e6067abfc995abb3d');
    expect(child.subscriptions.single.curriculumId, '6a83284e6067abfc995abb3d');
  });

  test('Egyptian registration mode is read from the child sibling field', () {
    final child = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'registrationMode': 'egyptian',
          'curriculum': {'id': 'egyptian-curriculum'},
          'student': {'id': 'student-1'},
          'subscriptions': [
            {'id': 'sub'},
          ],
        },
      ],
    }).children.single;

    expect(child.registrationMode, 'egyptian');
    expect(child.curriculumId, 'egyptian-curriculum');
  });

  test('missing or legacy mode is not inferred', () {
    for (final mode in [null, 'saudi']) {
      final child = ParentSubscriptionsResponse.fromJson({
        'data': [
          {
            'registrationMode': mode,
            'student': {'id': 'student-1'},
            'subscriptions': [
              {'id': 'sub', 'planKind': 'gulf', 'currency': 'SAR'},
            ],
          },
        ],
      }).children.single;

      expect(child.registrationMode, isNull);
    }
  });

  test('canRenew uses backend value only with a safe false default', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1'},
          'subscriptions': [
            {
              'id': 'allowed',
              'packageType': 'hours',
              'remainingHours': 4,
              'status': 'active',
              'canRenew': true,
            },
            {
              'id': 'denied',
              'packageType': 'monthly',
              'endDate': '2026-01-01T00:00:00.000Z',
              'status': 'expired',
              'canRenew': false,
            },
            {'id': 'missing', 'status': 'expired'},
          ],
        },
      ],
    });

    final subscriptions = response.children.single.subscriptions;
    expect(subscriptions.first.canRenew, isTrue);
    expect(subscriptions[1].canRenew, isFalse);
    expect(subscriptions.last.canRenew, isFalse);
  });

  test('server allowance does not expose renewal while still active', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1'},
          'subscriptions': [
            {
              'id': 'active',
              'packageType': 'monthly',
              'endDate': DateTime.now()
                  .add(const Duration(days: 2))
                  .toIso8601String(),
              'status': 'active',
              'canRenew': false,
            },
          ],
        },
      ],
    });

    expect(response.children.single.subscriptions.single.canRenew, isFalse);
  });

  test('computed lifecycle fields override stale stored status', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'student': {'id': 'student-1'},
          'subscriptions': [
            {
              'id': 'hours',
              'packageType': 'hours',
              'remainingHours': 0,
              'status': 'active',
              'computedStatus': 'expired',
              'isActive': false,
              'canRenew': true,
              'gracePeriodEndsAt': '2026-09-05T00:00:00.000Z',
              'renewalDueDate': '2026-09-01T00:00:00.000Z',
            },
          ],
        },
      ],
    });
    final subscription = response.children.single.subscriptions.single;
    expect(subscription.effectiveStatus, 'expired');
    expect(subscription.isActive, isFalse);
    expect(subscription.gracePeriodEndsAt, isNotNull);
    expect(subscription.renewalDueDate, isNotNull);
    expect(subscription.canRenew, isTrue);
  });

  test('monthly grace period renews even while isActive remains true', () {
    final subscription = ParentChildSubscriptionModel.fromJson({
      'id': 'monthly',
      'packageType': 'monthly',
      'endDate': DateTime.now()
          .subtract(const Duration(minutes: 1))
          .toIso8601String(),
      'computedStatus': 'grace_period',
      'isActive': true,
      'canRenew': true,
    });
    expect(subscription.canRenew, isTrue);
  });

  test('hours cannot renew before remaining hours reach zero', () {
    final subscription = ParentChildSubscriptionModel.fromJson({
      'id': 'hours',
      'packageType': 'hours',
      'remainingHours': 1,
      'status': 'expired',
      'canRenew': false,
    });
    expect(subscription.canRenew, isFalse);
  });
}
