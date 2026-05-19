import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class MyNavigator {
  static Future<T?> goTo<T>(
    BuildContext context,
    String path, {
    Object? extra,
  }) async {
    return await context.push<T>(path, extra: extra);
  }

  static void goToOff(BuildContext context, String path, {Object? extra}) {
    context.replace(path, extra: extra);
  }

  static void goToOffAll(BuildContext context, String path, {Object? extra}) {
    context.go(path, extra: extra);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    context.pop<T>(result);
  }
}
