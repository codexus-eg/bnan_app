import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bnan_app/features/payments/presentation/manager/tamara_payment_cubit.dart';
import 'package:flutter/material.dart';

class TamaraReturnObserver extends StatefulWidget {
  const TamaraReturnObserver({
    required this.cubit,
    required this.child,
    super.key,
  });

  final TamaraPaymentCubit cubit;
  final Widget child;

  @override
  State<TamaraReturnObserver> createState() => _TamaraReturnObserverState();
}

class _TamaraReturnObserverState extends State<TamaraReturnObserver>
    with WidgetsBindingObserver {
  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final links = AppLinks();
    _subscription = links.uriLinkStream.listen(widget.cubit.handleReturn);
    unawaited(_handleInitialLink(links));
  }

  Future<void> _handleInitialLink(AppLinks links) async {
    final initial = await links.getInitialLink();
    if (initial != null) {
      await widget.cubit.handleReturn(initial);
      return;
    }
    await widget.cubit.onForeground();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(widget.cubit.onForeground());
    } else if (state != AppLifecycleState.hidden) {
      widget.cubit.onBackground();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
