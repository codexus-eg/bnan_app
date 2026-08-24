import 'dart:async';

import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/connectivity/connectivity_cubit.dart';
import 'package:bnan_app/core/helper/theme_helper.dart';
import 'package:bnan_app/core/localization/language_manager/language_manager.dart';
import 'package:bnan_app/core/localization/language_manager/language_state.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_invalidator.dart';
import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback.dart';
import 'package:bnan_app/core/shared_widget/global_connectivity_overlay.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/payments/presentation/widgets/tamara_return_observer.dart';
import 'package:bnan_app/features/student_auth/data/models/otp_flow_args.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_notification_service.dart';
import 'package:bnan_app/features/push_notifications/presentation/local_push_notifications.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class BnanApp extends StatefulWidget {
  const BnanApp({super.key});

  @override
  State<BnanApp> createState() => _BnanAppState();
}

class _BnanAppState extends State<BnanApp> with WidgetsBindingObserver {
  TamaraPaymentCubit? paymentCubit;
  String? _navigatedPaymentId;

  late final GoRouter _router;
  late final ChatNotificationCoordinator _chatNotifications;
  late final ConnectivityCubit _connectivity;
  late final LanguageCubit _language;
  late final NotificationsCubit _notifications;

  PushNotificationService? _pushNotifications;

  final _navigatorKey = GlobalKey<NavigatorState>();

  static const _homePaths = <String>{
    Routes.home,
    Routes.teacherHome,
    Routes.adminHome,
    Routes.parentHome,
    Routes.supervisorHome,
  };

  static const _preLoginPaths = <String>{
    Routes.splash,
    Routes.onboarding,
    Routes.logIn,
    Routes.savedAccounts,
  };

  StreamSubscription<ChatNotificationEvent>? _chatNotificationSubscription;
  StreamSubscription<AppNotification>? _notificationFeedbackSubscription;
  StreamSubscription<AppNotification>? _notificationNavigationSubscription;
  StreamSubscription<void>? _sessionExpiredSubscription;

  AppTopFeedbackHandle? _chatFeedback;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _router = buildRouter(navigatorKey: _navigatorKey);

    _language = LanguageCubit();

    _connectivity = ConnectivityCubit();
    unawaited(_connectivity.startMonitoring());

    _sessionExpiredSubscription = SessionInvalidator.instance.expired.listen(
      _openLoginAfterSessionExpiry,
    );

    _chatNotifications = getIt<ChatNotificationCoordinator>();
    _notifications = getIt<NotificationsCubit>();

    _chatNotifications.setNotificationHandler(
      _notifications.ingestSocketNotification,
    );

    _chatNotificationSubscription = _chatNotifications.foregroundEvents.listen(
      _showChatNotification,
    );

    unawaited(_chatNotifications.initialize());

    _notificationFeedbackSubscription = _notifications.incoming.listen(
      _showForegroundNotification,
    );

    unawaited(_notifications.initialize());

    if (getIt.isRegistered<PushNotificationService>()) {
      _pushNotifications = getIt<PushNotificationService>();

      _notificationNavigationSubscription = _pushNotifications!
          .notificationOpened
          .listen(_openNotification);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_pushNotifications!.initialize());
        }
      });
    }

    if (getIt.isRegistered<TamaraPaymentCubit>()) {
      paymentCubit = getIt<TamaraPaymentCubit>()..restore();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_connectivity.checkConnection(showChecking: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _language),
        BlocProvider.value(value: _connectivity),
        BlocProvider.value(value: _notifications),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        buildWhen: (previous, current) => previous.locale != current.locale,
        builder: (context, state) {
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
            locale: state.locale,
            title: 'Bnan App',
            routerConfig: _router,
            theme: ThemeHelper.getTheme(),
          );

          final cubit = paymentCubit;

          return cubit == null
              ? app
              : BlocProvider.value(value: cubit, child: app);
        },
      ),
    );
  }

  void _showChatNotification(ChatNotificationEvent event) {
    final context = _navigatorKey.currentContext;
    final overlay = _navigatorKey.currentState?.overlay;

    if (context == null || overlay == null) {
      return;
    }

    final sender = event.senderName.isEmpty
        ? S.current.messages
        : event.senderName;

    _dismissChatNotification();

    _chatFeedback = AppTopFeedback.show(
      context,
      overlay: overlay,
      type: AppTopFeedbackType.notification,
      title: event.roomName.isEmpty ? sender : event.roomName,
      body: event.roomName.isEmpty
          ? event.message
          : '$sender: ${event.message}',
      dedupKey: 'chat:${event.messageId}',
      onTap: event.roomId.isEmpty
          ? null
          : () => unawaited(_openNotification(_chatEventNotification(event))),
    );
  }

  void _dismissChatNotification() {
    final feedback = _chatFeedback;

    _chatFeedback = null;

    if (feedback != null) {
      AppTopFeedback.dismiss(feedback);
    }
  }

  void _showForegroundNotification(AppNotification notification) {
    final key = notification.key.trim().toUpperCase();
    if (key == 'NEW_MESSAGE') {
      return;
    }

    if ((defaultTargetPlatform != TargetPlatform.iOS ||
            key == 'CHAT_NUDGE' ||
            key == 'STUDENT_CALL_ALERT') &&
        getIt.isRegistered<LocalPushNotifications>()) {
      unawaited(
        getIt<LocalPushNotifications>().showNotification(
          notification,
          appState: 'foreground',
        ),
      );
      if (key == 'CHAT_NUDGE') return;
    }

    final context = _navigatorKey.currentContext;
    final overlay = _navigatorKey.currentState?.overlay;

    if (context == null || overlay == null) {
      return;
    }

    AppTopFeedback.show(
      context,
      overlay: overlay,
      type: AppTopFeedbackType.notification,
      title: notification.title.isEmpty
          ? S.current.notifications
          : notification.title,
      body: notification.body,
      dedupKey: notification.id.isEmpty
          ? '${notification.key}|${notification.createdAt}'
          : notification.id,
      onTap: () => unawaited(_openNotification(notification)),
    );
  }

  Future<void> _openNotification(AppNotification notification) async {
    final destination = await getIt<NotificationNavigationService>()
        .resolveDestination(notification);

    final targetPath = Uri.parse(destination.path).path;
    final currentPath = _router.routeInformationProvider.value.uri.path;

    if (currentPath == targetPath) return;

    if (_homePaths.contains(targetPath)) {
      _router.go(destination.path, extra: destination.extra);
      return;
    }

    if (_preLoginPaths.contains(currentPath)) {
      await _waitUntilHome();
      if (!mounted ||
          _router.routeInformationProvider.value.uri.path == targetPath) {
        return;
      }
    }

    _router.push(destination.path, extra: destination.extra);
  }

  Future<void> _waitUntilHome() async {
    if (_isHomePath(_router.routerDelegate.currentConfiguration.uri.path)) {
      return;
    }
    final completer = Completer<void>();
    late final VoidCallback listener;
    listener = () {
      if (!_isHomePath(_router.routerDelegate.currentConfiguration.uri.path)) {
        return;
      }
      _router.routerDelegate.removeListener(listener);
      completer.complete();
    };
    _router.routerDelegate.addListener(listener);
    try {
      await completer.future.timeout(const Duration(seconds: 10));
    } on TimeoutException {
      _router.routerDelegate.removeListener(listener);
    }
  }

  bool _isHomePath(String path) => _homePaths.contains(path);

  AppNotification _chatEventNotification(ChatNotificationEvent event) =>
      AppNotification.fromJson({
        'id': event.messageId,
        'key': 'NEW_MESSAGE',
        'type': 'chat',
        'navigation': {
          'screen': 'chat_room',
          'params': {
            'roomId': event.roomId,
            'messageId': event.messageId,
            if (event.roomName.isNotEmpty) 'roomName': event.roomName,
          },
        },
      });

  void _openLoginAfterSessionExpiry(String? reason) {
    if (_router.routeInformationProvider.value.uri.path == Routes.logIn) {
      return;
    }

    _router.go(Routes.logIn);
    if (reason != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppTopFeedback.show(
          context,
          title: S.of(context).subscriptionAccessExpired,
          type: AppTopFeedbackType.warning,
        );
      });
    }
  }

  Widget _builder(BuildContext context, Widget? child) {
    final mediaQuery = MediaQuery.of(context);

    final scale = (mediaQuery.size.width / 375).clamp(0.85, 1.05);

    final cubit = paymentCubit;

    final scaledChild = MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
      child: child!,
    );

    final observedChild = cubit == null
        ? scaledChild
        : BlocListener<TamaraPaymentCubit, TamaraPaymentState>(
            listener: (context, state) {
              if (state is! TamaraPaymentResult ||
                  state.status != PaymentStatus.completed ||
                  !cubit.canOpenAccountVerification) {
                return;
              }

              final paymentId = cubit.draft?.paymentId ?? '';

              if (_navigatedPaymentId == paymentId) {
                return;
              }

              _navigatedPaymentId = paymentId;

              // IMPORTANT:
              // Do not use GoRouter.of(context) here.
              // This context belongs to MaterialApp.router.builder.
              _router.go(
                Routes.forgetPassword,
                extra: OtpFlowArgs.accountVerification(
                  cubit.draft?.studentEmail ?? '',
                ),
              );
            },
            child: TamaraReturnObserver(cubit: cubit, child: scaledChild),
          );

    return GlobalConnectivityOverlay(child: observedChild);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dismissChatNotification();

    unawaited(_chatNotificationSubscription?.cancel());

    unawaited(_notificationFeedbackSubscription?.cancel());

    unawaited(_notificationNavigationSubscription?.cancel());

    unawaited(_sessionExpiredSubscription?.cancel());

    final pushNotifications = _pushNotifications;

    if (pushNotifications != null) {
      unawaited(pushNotifications.dispose());
    }

    unawaited(_chatNotifications.dispose());

    unawaited(_connectivity.close());

    unawaited(_language.close());

    _router.dispose();

    super.dispose();
  }
}
