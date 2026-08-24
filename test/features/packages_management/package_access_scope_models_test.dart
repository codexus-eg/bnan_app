import 'package:bnan_app/features/packages_management/data/models/add_package_request_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy packages default to all subjects', () {
    final package = PackageModel.fromJson({'id': 'package-1'});

    expect(package.accessScope, PackageAccessScope.allSubjects);
  });

  test(
    'registration package parses packageType alias and normalizes scope',
    () {
      final package = PackageModel.fromJson({
        'packageType': ' HOURS ',
        'accessScope': ' SINGLE_SUBJECT ',
      });

      expect(package.type, 'hours');
      expect(package.accessScope, PackageAccessScope.singleSubject);
    },
  );

  test('create payload includes the selected access scope', () {
    const request = AddPackageRequestModel(
      name: 'Single subject',
      curriculum: 'egyptian-id',
      type: 'hours',
      accessScope: PackageAccessScope.singleSubject,
      hours: 12,
      oldPrice: 300,
      price: 250,
      currency: 'EGP',
    );

    expect(request.toJson()['accessScope'], PackageAccessScope.singleSubject);
  });
}
