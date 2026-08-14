import 'package:bnan_app/core/utils/styles_manager.dart';
import 'package:bnan_app/features/notifications/presentation/manager/preferences_cubit.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencesContent extends StatelessWidget {
  const PreferencesContent({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PreferencesCubit, PreferencesState>(
        builder: (context, state) {
          final value = state.value;
          if (value == null && state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (value == null) {
            return Center(
              child: Text(state.error ?? S.of(context).unexpectedError),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                S.of(context).notificationCategories,
                style: StylesManager.styleBold18(context),
              ),
              ...value.categories.entries.map(
                (entry) => _PreferenceTile(
                  title: _label(context, entry.key),
                  value: entry.value,
                  onChanged: (enabled) => context
                      .read<PreferencesCubit>()
                      .update('categories', entry.key, enabled),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).notificationChannels,
                style: StylesManager.styleBold18(context),
              ),
              ...value.channels.entries.map(
                (entry) => _PreferenceTile(
                  title: _label(context, entry.key),
                  value: entry.value,
                  onChanged: (enabled) => context
                      .read<PreferencesCubit>()
                      .update('channels', entry.key, enabled),
                ),
              ),
            ],
          );
        },
      );
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) => SwitchListTile.adaptive(
    contentPadding: EdgeInsets.zero,
    title: Text(title),
    value: value,
    onChanged: onChanged,
  );
}

String _label(BuildContext context, String key) => switch (key) {
  'chat' => S.of(context).notificationChat,
  'academic' => S.of(context).notificationAcademic,
  'finance' => S.of(context).notificationFinance,
  'attendance' => S.of(context).attendance,
  'announcements' => S.of(context).notificationAnnouncements,
  'admin' => S.of(context).notificationAdmin,
  'supervisor' => S.of(context).notificationSupervisor,
  'push' => S.of(context).notificationPush,
  'socket' => S.of(context).notificationInApp,
  _ => key,
};
