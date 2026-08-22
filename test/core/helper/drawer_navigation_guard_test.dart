import 'package:bnan_app/core/helper/drawer_navigation_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts one action per drawer opening', () {
    final guard = DrawerNavigationGuard();

    expect(guard.begin(), isTrue);
    expect(guard.begin(), isFalse);

    guard.drawerChanged(false);
    expect(guard.begin(), isFalse);

    guard.drawerChanged(true);
    expect(guard.begin(), isTrue);
  });
}
