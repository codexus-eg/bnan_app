import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


Widget defaultTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final isEnglish = Intl.defaultLocale == 'en';
  final beginOffset = isEnglish ? const Offset(1, 0) : const Offset(-1, 0);
  const  endOffset = Offset.zero;

  final tween = Tween<Offset>(
    begin: beginOffset,
    end: endOffset,
  ).chain(CurveTween(curve: Curves.easeInOut));
  return FadeTransition(
    opacity: animation,
    child: SlideTransition(position: animation.drive(tween), child: child),
  );
}

CustomTransitionPage<T> buildTransitionPages<T>({
  required Widget child,
  required LocalKey key,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: defaultTransition,
  );
}
