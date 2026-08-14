import 'dart:async';

import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/theme_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_invalidator.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_route.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_foreground_notification.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_state.dart';
import 'package:bnan_app/features/payments/presentation/widgets/tamara_return_observer.dart';
import 'package:bnan_app/features/push_notifications/presentation/push_notification_service.dart';
import 'package:bnan_app/features/notifications/data/models/app_notification.dart';
import 'package:bnan_app/features/notifications/domain/notification_navigation_service.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
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
  late final GoRouter _router;
  late final ChatNotificationCoordinator _chatNotifications;
  late final NotificationsCubit _notifications;
  PushNotificationService? _pushNotifications;
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<ChatNotificationEvent>? _chatNotificationSubscription;
  StreamSubscription<AppNotification>? _notificationNavigationSubscription;
  StreamSubscription<void>? _sessionExpiredSubscription;
  OverlayEntry? _chatNotificationEntry;
  Timer? _chatNotificationTimer;

  @override
  void initState() {
    super.initState();
    _router = buildRouter();
    _sessionExpiredSubscription = SessionInvalidator.instance.expired.listen(
      (_) => _openLoginAfterSessionExpiry(),
    );
    _chatNotifications = getIt<ChatNotificationCoordinator>();
    _chatNotificationSubscription = _chatNotifications.foregroundEvents.listen(
      _showChatNotification,
    );
    unawaited(_chatNotifications.initialize());
    _notifications = getIt<NotificationsCubit>();
    unawaited(_notifications.initialize());
    if (getIt.isRegistered<PushNotificationService>()) {
      _pushNotifications = getIt<PushNotificationService>();
      _notificationNavigationSubscription = _pushNotifications!
          .notificationOpened
          .listen(_openNotification);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) unawaited(_pushNotifications!.initialize());
      });
    }
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
      scaffoldMessengerKey: _messengerKey,
      routerConfig: _router,
      theme: ThemeHelper.getTheme(),
    );
    final cubit = paymentCubit;
    final result = cubit == null
        ? app
        : BlocProvider.value(value: cubit, child: app);
    return BlocProvider.value(value: _notifications, child: result);
  }

  void _showChatNotification(ChatNotificationEvent event) {
    final context = _messengerKey.currentContext;
    final overlay = context == null
        ? null
        : Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    final route = ChatNotificationRoute.path(event.roomId);
    final sender = event.senderName.isEmpty
        ? S.current.messages
        : event.senderName;
    _dismissChatNotification();
    _chatNotificationEntry = OverlayEntry(
      builder: (context) => PositionedDirectional(
        top: MediaQuery.paddingOf(context).top + 8,
        start: 12,
        end: 12,
        child: ChatForegroundNotification(
          sender: sender,
          preview: event.message,
          onTap: () {
            _dismissChatNotification();
            if (route != null) _router.push(route);
          },
        ),
      ),
    );
    overlay.insert(_chatNotificationEntry!);
    _chatNotificationTimer = Timer(
      const Duration(seconds: 4),
      _dismissChatNotification,
    );
  }

  void _dismissChatNotification() {
    _chatNotificationTimer?.cancel();
    _chatNotificationTimer = null;
    _chatNotificationEntry?.remove();
    _chatNotificationEntry = null;
  }

  void _openNotification(AppNotification notification) {
    final route = getIt<NotificationNavigationService>().resolve(notification);
    if (_router.routeInformationProvider.value.uri.path == route) return;
    _router.push(route);
  }

  void _openLoginAfterSessionExpiry() {
    if (_router.routeInformationProvider.value.uri.path == Routes.logIn) return;
    _router.go(Routes.logIn);
  }

  @override
  void dispose() {
    _dismissChatNotification();
    unawaited(_chatNotificationSubscription?.cancel());
    unawaited(_notificationNavigationSubscription?.cancel());
    unawaited(_sessionExpiredSubscription?.cancel());
    final pushNotifications = _pushNotifications;
    if (pushNotifications != null) unawaited(pushNotifications.dispose());
    unawaited(_chatNotifications.dispose());
    _router.dispose();
    super.dispose();
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
