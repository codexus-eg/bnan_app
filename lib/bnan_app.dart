import 'dart:async';

import 'package:bnan_app/core/app_routes/app_router.dart';
import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/theme_helper.dart';
import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/session/session_invalidator.dart';
import 'package:bnan_app/core/shared_widget/app_top_feedback/app_top_feedback.dart';
import 'package:bnan_app/features/payments/data/models/payment_status.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_coordinator.dart';
import 'package:bnan_app/features/chats/presentation/notifications/chat_notification_event.dart';
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
  final _navigatorKey = GlobalKey<NavigatorState>();
  StreamSubscription<ChatNotificationEvent>? _chatNotificationSubscription;
  StreamSubscription<AppNotification>? _notificationFeedbackSubscription;
  StreamSubscription<AppNotification>? _notificationNavigationSubscription;
  StreamSubscription<void>? _sessionExpiredSubscription;
  AppTopFeedbackHandle? _chatFeedback;

  @override
  void initState() {
    super.initState();
    _router = buildRouter(navigatorKey: _navigatorKey);
    _sessionExpiredSubscription = SessionInvalidator.instance.expired.listen(
      (_) => _openLoginAfterSessionExpiry(),
    );
    _chatNotifications = getIt<ChatNotificationCoordinator>();
    _chatNotificationSubscription = _chatNotifications.foregroundEvents.listen(
      _showChatNotification,
    );
    unawaited(_chatNotifications.initialize());
    _notifications = getIt<NotificationsCubit>();
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
    final context = _navigatorKey.currentContext;
    final overlay = _navigatorKey.currentState?.overlay;
    if (context == null || overlay == null) return;
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
    if (feedback != null) AppTopFeedback.dismiss(feedback);
  }

  void _showForegroundNotification(AppNotification notification) {
    if (notification.key.trim().toUpperCase() == 'NEW_MESSAGE') return;
    final context = _navigatorKey.currentContext;
    final overlay = _navigatorKey.currentState?.overlay;
    if (context == null || overlay == null) return;
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
    if (_router.routeInformationProvider.value.uri.path == destination.path) {
      return;
    }
    _router.push(destination.path, extra: destination.extra);
  }

  AppNotification _chatEventNotification(ChatNotificationEvent event) =>
      AppNotification.fromJson({
        'id': event.messageId,
        'key': 'NEW_MESSAGE',
        'type': 'chat',
        'navigation': {
          'screen': 'chat_room',
          'params': {
            'roomId': event.roomId,
            if (event.roomName.isNotEmpty) 'roomName': event.roomName,
          },
        },
      });

  void _openLoginAfterSessionExpiry() {
    if (_router.routeInformationProvider.value.uri.path == Routes.logIn) return;
    _router.go(Routes.logIn);
  }

  @override
  void dispose() {
    _dismissChatNotification();
    unawaited(_chatNotificationSubscription?.cancel());
    unawaited(_notificationFeedbackSubscription?.cancel());
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
