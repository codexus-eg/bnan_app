import 'package:bnan_app/features/admin/presentation/views/widgets/admin_departments_mapper.dart';
import 'package:bnan_app/features/admin/presentation/views/widgets/admin_stats_mapper.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'admin_dashboard_test_data.dart';

void main() {
  testWidgets('mapper shows API values and excludes revenue cards', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: const [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      home: Builder(builder: (value) {
        context = value;
        return const SizedBox();
      }),
    ));
    final stats = adminDashboardStats(
      context,
      dashboardStatistics(),
      () {},
      () {},
    );

    expect(stats.map((item) => item.value), containsAll(['29', '38', '6']));
    expect(stats.map((item) => item.title), isNot(contains(S.of(context).dailyProfits)));
    expect(stats.map((item) => item.title), isNot(contains(S.of(context).monthlyProfits)));
    final departments = adminDepartments(
      context,
      dashboardStatistics().studentsBySection,
    );
    expect(departments.first.percentageLabel, '62.07');
    expect(departments.first.progress, closeTo(.6207, .001));
  });
}
