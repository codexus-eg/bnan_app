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
  const PaymobCheckoutView({super.key, required this.checkoutUrl});

  final String checkoutUrl;

  @override
  State<PaymobCheckoutView> createState() => _PaymobCheckoutViewState();
}

class _PaymobCheckoutViewState extends State<PaymobCheckoutView> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) =>
              PaymobNavigationPolicy.decide(request.url),
          onPageStarted: (_) => _update(loading: true, failed: false),
          onPageFinished: (_) => _update(loading: false, failed: false),
          onWebResourceError: (error) {
            if (error.isForMainFrame != false) {
              _update(loading: false, failed: true);
            }
          },
        ),
      );
    unawaited(_load());
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
    if (!mounted) return;
    setState(() {
      _loading = loading;
      _failed = failed;
    });
  }

  void _close() => Navigator.pop(context, PaymobCheckoutOutcome.closed);

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
