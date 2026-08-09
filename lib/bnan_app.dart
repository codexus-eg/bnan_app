import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/theme_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/payments/presentation/widgets/tamara_return_observer.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class BnanApp extends StatefulWidget {
  const BnanApp({super.key});

  @override
  State<BnanApp> createState() => _BnanAppState();
}

class _BnanAppState extends State<BnanApp> {
  TamaraPaymentCubit? paymentCubit;
  String? _navigatedPaymentId;

  @override
  void initState() {
    super.initState();
    if (getIt.isRegistered<TamaraPaymentCubit>()) {
      paymentCubit = getIt<TamaraPaymentCubit>()..restore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: _builder,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('ar'),
      title: 'Bnan App',
      routerConfig: buildRouter(),
      theme: ThemeHelper.getTheme(),
    );
    final cubit = paymentCubit;
    return cubit == null ? app : BlocProvider.value(value: cubit, child: app);
  }

  Widget _builder(BuildContext context, Widget? child) {
    final mediaQuery = MediaQuery.of(context);
    final scale = (mediaQuery.size.width / 375).clamp(0.85, 1.05);
    final cubit = paymentCubit;
    final scaledChild = MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    );
    if (cubit == null) return scaledChild;
    return BlocListener<TamaraPaymentCubit, TamaraPaymentState>(
      listener: (context, state) {
        if (state is! TamaraPaymentResult ||
            state.status != PaymentStatus.completed) {
          return;
        }
        final paymentId = cubit.draft?.paymentId ?? '';
        if (_navigatedPaymentId == paymentId) return;
        _navigatedPaymentId = paymentId;
        GoRouter.of(context).go(
          state.studentLoggedIn ? Routes.home : Routes.logIn,
          extra: state.studentLoggedIn ? null : cubit.draft?.studentEmail,
        );
      },
      child: TamaraReturnObserver(cubit: cubit, child: scaledChild),
    );
  }
}
