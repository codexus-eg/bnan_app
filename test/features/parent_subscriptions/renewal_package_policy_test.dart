import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/policies/renewal_package_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Gulf hours renewal keeps hours package with a different scope', () {
    const package = PackageModel(
      id: 'hours-package',
      curriculum: 'saudi-curriculum',
      type: 'hours',
      accessScope: 'all_subjects',
      isActive: true,
    );

    expect(
      RenewalPackagePolicy.isVisible(
        package,
        registrationMode: 'gulf',
        curriculumId: 'saudi-curriculum',
        currentAccessScope: 'single_subject',
        currentPackageType: 'hours',
      ),
      isTrue,
    );
  });
}
