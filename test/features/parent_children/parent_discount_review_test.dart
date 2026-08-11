import 'package:bnan_app/features/academic_lookups/data/models/academic_curriculum_model.dart';
import 'package:bnan_app/features/packages_management/data/models/package_model.dart';
import 'package:bnan_app/features/parent_children/data/repo/parent_add_child_repo.dart';
import 'package:bnan_app/features/parent_children/presentation/manager/parent_add_child_cubit/parent_add_child_cubit.dart';
import 'package:bnan_app/features/parent_children/presentation/widgets/parent_price_review_step.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/data/models/parent_subscription_renewal_args.dart';
import 'package:bnan_app/features/parent_subscriptions/data/repo/parent_subscriptions_repo.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/manager/parent_subscription_renewal_cubit/parent_subscription_renewal_cubit.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/renewal_review_steps.dart';
import 'package:bnan_app/features/payments/data/idempotency_key_generator.dart';
import 'package:bnan_app/features/student_auth/presentation/views/widgets/student_registration_widgets/discount_code_field.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('controlled DiscountCodeField does not require RegisterCubit', (
    tester,
  ) async {
    await tester.pumpWidget(_app(DiscountCodeField(onChanged: (_) {})));
    expect(tester.takeException(), isNull);
  });

  testWidgets('parent add-child review does not require RegisterCubit', (
    tester,
  ) async {
    final cubit =
        ParentAddChildCubit(
            repo: _AddRepo(),
            keyGenerator: IdempotencyKeyGenerator(),
          )
          ..start(_curriculum)
          ..selectPackage(_package);
    await tester.pumpWidget(
      _app(
        BlocProvider.value(value: cubit, child: const ParentPriceReviewStep()),
      ),
    );
    expect(tester.takeException(), isNull);
    await cubit.close();
  });

  testWidgets('parent renewal review does not require RegisterCubit', (
    tester,
  ) async {
    final cubit = ParentSubscriptionRenewalCubit(
      repo: _RenewalRepo(),
      keyGenerator: IdempotencyKeyGenerator(),
      args: _args,
    )..selectPackage(_package);
    await tester.pumpWidget(
      _app(
        BlocProvider.value(value: cubit, child: const RenewalDiscountStep()),
      ),
    );
    expect(tester.takeException(), isNull);
    await cubit.close();
  });
}

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

const _curriculum = AcademicCurriculumModel(
  id: 'curriculum',
  name: 'Egypt',
  registrationMode: 'egyptian',
);
const _package = PackageModel(
  id: 'package',
  name: 'Package',
  curriculum: 'curriculum',
  type: 'hours',
  isActive: true,
);
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

class _AddRepo implements ParentAddChildRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _RenewalRepo implements ParentSubscriptionsRepo {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
