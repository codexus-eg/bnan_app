import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/features/admin/presentation/manager/admin_dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> openAdminRegistrationRequests(BuildContext context) async {
  await MyNavigator.goTo(context, Routes.registrationRequests);
  if (!context.mounted) return;
  await context.read<AdminDashboardCubit>().refresh();
}
