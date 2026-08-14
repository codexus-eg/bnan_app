import 'package:bnan_app/core/helper/validator_form_field.dart';
import 'package:bnan_app/features/packages_management/data/repo/packages_repo/packages_repo.dart';
import 'package:bnan_app/features/packages_management/presentation/manager/get_packages_cubit/get_packages_cubit.dart';
import 'package:bnan_app/features/student_auth/data/models/package_card_model.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_body.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_grid.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/subscription_widgets/subscription_plan_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'registration password is required and has minimum length six',
    () async {
      await S.load(const Locale('en'));
      for (final value in ['123456', 'abcdef', 'abc123', '12345678']) {
        expect(MyValidator.validateRegistrationPassword(value), isNull);
      }
      for (final value in ['', 'abc', '12345']) {
        expect(MyValidator.validateRegistrationPassword(value), isNotNull);
      }
    },
  );

  testWidgets(
    'packages have no currency dropdown and do not overflow at 320px',
    (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final cubit = GetPackagesCubit(_PackagesRepo());
      addTearDown(cubit.close);
      await tester.pumpWidget(
        _app(
          BlocProvider.value(
            value: cubit,
            child: const SubscriptionBody(
              curriculumId: 'curriculum',
              curriculumName: 'Curriculum',
            ),
          ),
        ),
      );
      expect(find.byType(DropdownButton<String>), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('selected and unselected package cards have equal dimensions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      _app(
        PackagesGrid(
          plans: [_plan('selected'), _plan('other')],
          packages: const [],
          curriculumId: 'curriculum',
          curriculumName: 'Curriculum',
          selectedPackageId: 'selected',
        ),
      ),
    );
    final cards = find.byType(SubscriptionPlanCard);
    expect(tester.getSize(cards.at(0)), tester.getSize(cards.at(1)));
    expect(tester.takeException(), isNull);
  });
}

PackageCardModel _plan(String id) => PackageCardModel(
  id: id,
  title: id == 'selected' ? 'باقة طويلة جدًا للاختبار' : 'باقة',
  durationText: '8 ساعات',
  oldPriceText: id == 'selected' ? '999999 ج.م' : '',
  priceText: '999999999 ج.م',
  saveText: id == 'selected' ? 'وفر 100 ج.م' : '',
  isPopular: false,
  price: 250,
  currency: 'EGP',
  isSingleSubject: id == 'selected',
);

Widget _app(Widget child) => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: child),
);

class _PackagesRepo implements PackagesRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
