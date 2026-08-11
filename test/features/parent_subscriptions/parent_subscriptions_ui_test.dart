import 'package:bnan_app/features/parent_subscriptions/data/models/parent_child_subscription_model.dart';
import 'package:bnan_app/features/parent_subscriptions/presentation/widgets/parent_subscription_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('single-subject subscriptions render as independent cards', (
    tester,
  ) async {
    const child = ParentChildSubscriptionsModel(
      studentId: 'child',
      studentName: 'Child',
      subscriptions: [],
    );
    const subscriptions = [
      ParentChildSubscriptionModel(
        id: 'one',
        packageId: 'p',
        packageName: 'Math package',
        curriculumId: 'c',
        accessScope: 'single_subject',
        subject: ParentSubscriptionSubjectModel(id: 'math', name: 'Math'),
      ),
      ParentChildSubscriptionModel(
        id: 'two',
        packageId: 'p',
        packageName: 'Science package',
        curriculumId: 'c',
        accessScope: 'single_subject',
        subject: ParentSubscriptionSubjectModel(id: 'science', name: 'Science'),
      ),
    ];
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
          body: ListView(
            children: subscriptions
                .map(
                  (item) => ParentSubscriptionCard(
                    child: child,
                    subscription: item,
                    showRenew: false,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(ParentSubscriptionCard), findsNWidgets(2));
    expect(find.text('Math'), findsOneWidget);
    expect(find.text('Science'), findsOneWidget);
  });

  testWidgets('long subscription text does not overflow on a small screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    const child = ParentChildSubscriptionsModel(
      studentId: 'child',
      studentName: 'A very long student name that must remain responsive',
      subscriptions: [],
    );
    const subscription = ParentChildSubscriptionModel(
      id: 'sub',
      packageId: 'package',
      packageName: 'A very long package name that should wrap safely',
      curriculumId: 'curriculum',
      accessScope: 'single_subject',
      packageType: 'hours',
      status: 'a_very_long_payment_and_subscription_status',
      subject: ParentSubscriptionSubjectModel(
        id: 'subject',
        name: 'A very long assigned subject name that should not overflow',
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: ParentSubscriptionCard(
              child: child,
              subscription: subscription,
              showRenew: false,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
