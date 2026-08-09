import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('single subject is Egyptian-only and forces hourly type', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('egyptian-id', 'egyptian');
    cubit.setType('monthly');

    cubit.setAccessScope(PackageAccessScope.singleSubject);
    cubit.setType('monthly');

    expect(cubit.state.accessScope, PackageAccessScope.singleSubject);
    expect(cubit.state.packageType, 'hours');
  });

  test('changing to Gulf resets a single-subject package scope', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('egyptian-id', 'egyptian');
    cubit.setAccessScope(PackageAccessScope.singleSubject);

    cubit.setCurriculum('gulf-id', 'gulf');

    expect(cubit.state.accessScope, PackageAccessScope.allSubjects);
    expect(cubit.state.canSelectSingleSubject, isFalse);
  });
}
