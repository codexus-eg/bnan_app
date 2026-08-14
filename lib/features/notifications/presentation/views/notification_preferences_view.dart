import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/notifications/presentation/manager/preferences_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/preferences_content.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPreferencesView extends StatelessWidget {
  const NotificationPreferencesView({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<PreferencesCubit>()..load(),
    child: Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).notificationSettings),
      body: const PreferencesContent(),
    ),
  );
}
