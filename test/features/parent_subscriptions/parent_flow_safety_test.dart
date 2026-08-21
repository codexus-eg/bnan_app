import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscriptions_response.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/parent_renewal_route_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PackageModel parses String, Map, and null curriculum', () {
    expect(PackageModel.fromJson({'curriculum': 'c1'}).curriculum, 'c1');
    expect(
      PackageModel.fromJson({
        'curriculum': {'_id': 'c2'},
      }).curriculum,
      'c2',
    );
    expect(PackageModel.fromJson(const {}).curriculum, isNull);
  });

  test('parent child reads sibling curriculum and registration mode', () {
    final response = ParentSubscriptionsResponse.fromJson({
      'data': [
        {
          'registrationMode': 'egyptian',
          'curriculumId': 'curriculum-1',
          'student': {'id': 'child', 'name': 'Student'},
          'subscriptions': [
            {'id': 'sub', 'packageId': 'package'},
          ],
        },
      ],
    });
    final child = response.children.single;
    expect(child.registrationMode, 'egyptian');
    expect(child.curriculumId, 'curriculum-1');
    expect(child.subscriptions.single.curriculumId, 'curriculum-1');
  });

  test('renewal route rejects missing, wrong, and mismatched extra', () {
    expect(isValidParentRenewalRoute(studentId: 'child'), isFalse);
    expect(
      isValidParentRenewalRoute(studentId: 'child', extra: Object()),
      isFalse,
    );
    expect(
      isValidParentRenewalRoute(studentId: 'other', extra: _args),
      isFalse,
    );
    expect(isValidParentRenewalRoute(studentId: 'child', extra: _args), isTrue);
    expect(
      isValidParentRenewalRoute(
        studentId: 'child',
        extra: ParentSubscriptionRenewalArgs(
          studentId: 'child',
          curriculumId: '',
          subscription: _subscription,
          subjects: const [],
          registrationMode: 'gulf',
        ),
      ),
      isFalse,
    );
    expect(
      isValidParentRenewalRoute(
        studentId: 'child',
        extra: ParentSubscriptionRenewalArgs(
          studentId: 'child',
          curriculumId: 'curriculum',
          subscription: _subscription,
          subjects: const [],
          registrationMode: 'egyptian',
          isParent: false,
        ),
      ),
      isFalse,
    );
  });
}

const _subscription = ParentChildSubscriptionModel(
  id: 'sub',
  packageId: 'package',
  packageName: 'Package',
  curriculumId: 'curriculum',
);
const _args = ParentSubscriptionRenewalArgs(
  studentId: 'child',
  curriculumId: 'curriculum',
  subscription: _subscription,
  subjects: [],
  registrationMode: 'egyptian',
);
