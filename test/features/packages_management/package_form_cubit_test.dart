import 'package:bnan_app/features/packages_management/data/models/package_access_scope.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/package_form_cubit/package_form_cubit.dart';
import 'package:bnan_app/features/packages_management/presentation/mappers/admin_package_card_mapper.dart';
import 'package:bnan_app/features/packages_management/presentation/widgets/package_type_selector.dart';
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

  test('changing to Gulf resets a single-subject package scope', () {
    final cubit = PackageFormCubit();
    cubit.setCurriculum('egyptian-id', 'egyptian');
    cubit.setAccessScope(PackageAccessScope.singleSubject);

    cubit.setCurriculum('gulf-id', 'gulf');

    expect(cubit.state.accessScope, PackageAccessScope.allSubjects);
    expect(cubit.state.canSelectSingleSubject, isFalse);
    expect(cubit.state.packageType, 'hours');
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

  testWidgets('Admin package card uses the package currency', (tester) async {
    late String price;
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
            price = AdminPackageCardMapper.fromPackage(
              context,
              const PackageModel(price: 120, oldPrice: 200, currency: 'EGP'),
            ).priceText;
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(price, contains('E£'));
    expect(price, isNot(contains('SAR')));
  });
}
