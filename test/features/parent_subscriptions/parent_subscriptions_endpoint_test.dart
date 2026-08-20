import 'package:bnan_app/core/network/end_points.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parent subscriptions use the backend contract endpoint', () {
    expect(
      EndPoints.parentChildrenSubscriptions,
      '/parents/children-subscriptions',
    );
  });
}
