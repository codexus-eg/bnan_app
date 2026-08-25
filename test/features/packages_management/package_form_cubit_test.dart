import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/mappers/admin_package_card_mapper.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_type_selector.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

  test('changing to Gulf forces a single-subject package scope', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('egyptian-id', 'egyptian');
    cubit.setAccessScope(PackageAccessScope.singleSubject);

    cubit.setCurriculum('gulf-id', 'gulf');

    expect(cubit.state.accessScope, PackageAccessScope.singleSubject);
    expect(cubit.state.canSelectSingleSubject, isFalse);
    expect(cubit.state.packageType, 'hours');
  });

  test('Gulf package scope cannot be changed to all subjects', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('gulf-id', 'gulf');

    cubit.setAccessScope(PackageAccessScope.allSubjects);

    expect(cubit.state.accessScope, PackageAccessScope.singleSubject);
    expect(cubit.state.effectiveAccessScope, PackageAccessScope.singleSubject);
  });

  test('Gulf rejects monthly type while Egyptian keeps it', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('gulf-id', 'gulf');
    cubit.setType('monthly');
    expect(cubit.state.effectivePackageType, 'hours');

    cubit.setCurriculum('egyptian-id', 'egyptian');
    cubit.setType('monthly');
    expect(cubit.state.packageType, 'monthly');
  });

  test('editing a legacy monthly Gulf package normalizes it to hours', () {
    final cubit = PackageFormCubit();
    cubit.initialize(
      const PackageModel(
        id: 'package-id',
        curriculum: 'gulf-id',
        type: 'monthly',
      ),
      const {'gulf-id': 'gulf'},
    );

    expect(cubit.state.packageType, 'hours');
    expect(cubit.state.accessScope, PackageAccessScope.singleSubject);
  });

  testWidgets('Gulf type selector does not build the monthly option', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: PackageTypeSelector(
            value: 'hours',
            showMonthly: false,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(S.current.monthlyPackage), findsNothing);
    expect(find.text(S.current.packageHoursType), findsOneWidget);
    final selector = tester.getRect(find.byType(PackageTypeSelector));
    final option = tester.getRect(
      find.ancestor(
        of: find.text(S.current.packageHoursType),
        matching: find.byType(InkWell),
      ),
    );
    expect(option.width, lessThan(selector.width));
    expect(option.right, closeTo(selector.right, 0.1));
  });

  testWidgets('Egyptian type selector keeps two equal options', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: PackageTypeSelector(value: 'monthly', onChanged: (_) {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final monthly = tester.getSize(
      find.ancestor(
        of: find.text(S.current.monthlyPackage),
        matching: find.byType(InkWell),
      ),
    );
    final hours = tester.getSize(
      find.ancestor(
        of: find.text(S.current.packageHoursType),
        matching: find.byType(InkWell),
      ),
    );
    expect(monthly.width, closeTo(hours.width, 0.1));
  });

  testWidgets('Admin package card displays ISO currency codes', (tester) async {
    late String egpPrice;
    late String sarPrice;
    late PackageCardModel sharedPackage;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Builder(
          builder: (context) {
            egpPrice = AdminPackageCardMapper.fromPackage(
              context,
              const PackageModel(price: 120, oldPrice: 200, currency: 'EGP'),
            ).priceText;
            sarPrice = AdminPackageCardMapper.fromPackage(
              context,
              const PackageModel(price: 100, oldPrice: 150, currency: 'SAR'),
            ).priceText;
            sharedPackage = PackageCardModel.fromPackage(
              context: context,
              package: const PackageModel(
                price: 200,
                oldPrice: 250,
                currency: 'EGP',
              ),
            );
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(egpPrice, '120 EGP');
    expect(sarPrice, '100 SAR');
    expect(sharedPackage.priceText, '200 EGP');
    expect(sharedPackage.oldPriceText, '250 EGP');
    expect(sharedPackage.saveText, contains('50 EGP'));
  });
}
