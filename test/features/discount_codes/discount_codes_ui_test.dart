import 'package:bnan_app/core/error/failure.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/features/discount_codes/data/models/discount_code_model.dart';
import 'package:bnan_app/features/discount_codes/data/repos/discount_codes_repo.dart';
import 'package:bnan_app/features/discount_codes/presentation/manager/discount_codes_cubit.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_codes_content.dart';
import 'package:bnan_app/features/discount_codes/presentation/views/widgets/discount_code_card.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('expired code card shows inactive without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 560);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _localizedApp(
        DiscountCodeCard(
          code: DiscountCodeModel(
            id: 'expired',
            code: 'OLD10',
            type: DiscountCodeType.dateRange,
            percentage: 10,
            isActive: true,
            startsAt: DateTime(2020),
            endsAt: DateTime(2020, 1, 2),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(S.current.inactive), findsOneWidget);
    expect(find.text(S.current.active), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows centered NoData after an empty load', (tester) async {
    final cubit = DiscountCodesCubit(_Repo())..load();
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: DiscountCodesContent()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NoDataWidget), findsOneWidget);
    await cubit.close();
  });
}

Widget _localizedApp(Widget child) => MaterialApp(
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  home: Scaffold(body: child),
);

class _Repo implements DiscountCodesRepo {
  @override
  Future<Either<Failure, List<DiscountCodeModel>>> getAll() async =>
      const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
