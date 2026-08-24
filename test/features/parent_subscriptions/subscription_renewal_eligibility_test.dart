import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/subscription_renewal_eligibility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 23, 12);

  test('hours require backend approval and no remaining hours', () {
    expect(_eligible(_hours(remaining: 5), now), isFalse);
    expect(_eligible(_hours(remaining: 0), now), isTrue);
    expect(_eligible(_hours(remaining: 0, canRenew: false), now), isFalse);
  });

  test('monthly requires backend approval and reached end date', () {
    expect(_eligible(_monthly(DateTime.utc(2026, 8, 24)), now), isFalse);
    expect(_eligible(_monthly(DateTime.utc(2026, 8, 23, 12)), now), isTrue);
    expect(_eligible(_monthly(DateTime.utc(2026, 8, 22)), now), isTrue);
    expect(_eligible(_monthly(null), now), isFalse);
    expect(
      _eligible(_monthly(DateTime.utc(2026, 8, 22), canRenew: false), now),
      isFalse,
    );
  });

  test('Gulf depends only on remaining hours', () {
    expect(
      _eligible(
        _hours(remaining: 0, canRenew: false, pending: true),
        now,
        mode: 'gulf',
      ),
      isTrue,
    );
    expect(_eligible(_hours(remaining: 1), now, mode: 'gulf'), isFalse);
    expect(
      _eligible(
        _hours(
          remaining: 0,
          endDate: DateTime.utc(2026, 8, 24),
          canRenew: false,
          pending: true,
        ),
        now,
        mode: 'gulf',
      ),
      isTrue,
    );
  });

  test('pending renewal blocks Egyptian', () {
    expect(
      _eligible(_hours(remaining: 0, pending: true), now, mode: 'egyptian'),
      isFalse,
    );
    expect(
      _eligible(
        _monthly(DateTime.utc(2026, 8, 22), pending: true),
        now,
        mode: 'egyptian',
      ),
      isFalse,
    );
  });
}

bool _eligible(
  ParentChildSubscriptionModel value,
  DateTime now, {
  String? mode,
}) => SubscriptionRenewalEligibility.canRenew(
  value,
  registrationMode: mode,
  now: now,
);

ParentChildSubscriptionModel _hours({
  required num remaining,
  DateTime? endDate,
  bool canRenew = true,
  bool pending = false,
}) => _subscription(
  type: 'hours',
  remainingHours: remaining,
  endDate: endDate,
  canRenew: canRenew,
  pending: pending,
);

ParentChildSubscriptionModel _monthly(
  DateTime? endDate, {
  bool canRenew = true,
  bool pending = false,
}) => _subscription(
  type: 'monthly',
  endDate: endDate,
  canRenew: canRenew,
  pending: pending,
);

ParentChildSubscriptionModel _subscription({
  required String type,
  num remainingHours = 0,
  DateTime? endDate,
  bool canRenew = true,
  bool pending = false,
}) => ParentChildSubscriptionModel(
  id: 'subscription',
  packageId: 'package',
  packageName: 'Package',
  curriculumId: 'curriculum',
  packageType: type,
  remainingHours: remainingHours,
  endDate: endDate,
  canRenew: canRenew,
  hasPendingRenewal: pending,
);
