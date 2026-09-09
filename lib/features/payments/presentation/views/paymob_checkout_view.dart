import 'dart:async';

import 'package:bnan_app/core/shared_widget/custom_app_button.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/payments/presentation/views/paymob_navigation_policy.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum PaymobCheckoutOutcome { closed }

class PaymobCheckoutView extends StatefulWidget {
  const PaymobCheckoutView({
    super.key,
    required this.checkoutUrl,
    this.completionStream,
    this.isCompleted,
    this.onPaymentSuccess,
  });

  final String checkoutUrl;
  final Stream<bool>? completionStream;
  final bool Function()? isCompleted;
  final Future<void> Function()? onPaymentSuccess;

  @override
  State<PaymobCheckoutView> createState() => _PaymobCheckoutViewState();
}

class _PaymobCheckoutViewState extends State<PaymobCheckoutView> {
  late final WebViewController _controller;
  StreamSubscription<bool>? _completionSubscription;
  bool _loading = true;
  bool _failed = false;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _completionSubscription = widget.completionStream?.listen((completed) {
      if (completed) _handleSuccessAndClose();
    });
    if (widget.isCompleted?.call() == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSuccessAndClose();
      });
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: _onNavigationRequest,
          onPageStarted: (url) {
            _checkSuccessUrl(url);
            _update(loading: true, failed: false);
          },
          onPageFinished: (url) {
            _checkSuccessUrl(url);
            _update(loading: false, failed: false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame != false) {
              _update(loading: false, failed: true);
            }
          },
        ),
      );
    unawaited(_load());
  }

  @override
  void dispose() {
    _completionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    _update(loading: true, failed: false);
    try {
      await _controller.loadRequest(Uri.parse(widget.checkoutUrl));
    } catch (_) {
      _update(loading: false, failed: true);
    }
  }

  void _update({required bool loading, required bool failed}) {
    if (_closing || !mounted) return;
    setState(() {
      _loading = loading;
      _failed = failed;
    });
  }

  void _checkSuccessUrl(String url) {
    if (PaymobNavigationPolicy.isSuccessReturnUrl(url)) {
      _handleSuccessAndClose();
    }
  }

  void _handleSuccessAndClose() {
    if (_closing || !mounted) return;
    _closing = true;
    final callback = widget.onPaymentSuccess;
    if (callback != null) unawaited(callback());
    Navigator.pop(context, PaymobCheckoutOutcome.closed);
  }

  Future<NavigationDecision> _onNavigationRequest(
    NavigationRequest request,
  ) async {
    if (PaymobNavigationPolicy.isSuccessReturnUrl(request.url)) {
      _handleSuccessAndClose();
      return NavigationDecision.prevent;
    }
    return PaymobNavigationPolicy.decide(request.url);
  }

  void _close() {
    if (_closing || !mounted) return;
    _closing = true;
    Navigator.pop(context, PaymobCheckoutOutcome.closed);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _close();
    },
    child: Scaffold(
      // appBar: CustomAppbar(
      //   headerText: S.of(context).paymentMethod,
      //   onBackTap: _close,
      // ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: ColorManager.mainColor14),
            ),
          if (_failed) _error(context),
        ],
      ),
    ),
  );

  Widget _error(BuildContext context) => ColoredBox(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).errorUnknown,
              style: StylesManager.styleRegular14(context),
            ),
            const SizedBox(height: 16),
            CustomAppButton(text: S.of(context).retry, onPressed: _load),
          ],
        ),
      ),
    ),
  );
}
