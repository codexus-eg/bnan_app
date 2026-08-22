import 'package:bnan_app/features/notifications/presentation/manager/notifications_cubit.dart';
import 'package:bnan_app/features/notifications/presentation/manager/notifications_state.dart';
import 'package:bnan_app/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsList extends StatefulWidget {
  const NotificationsList({super.key, required this.state});
  final NotificationsState state;
  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  late final ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
  }

  void _loadMore() {
    if (_controller.position.extentAfter < 240) {
      context.read<NotificationsCubit>().load();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => context.read<NotificationsCubit>().load(refresh: true),
    child: ListView.separated(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.state.items.length + (widget.state.loadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => index == widget.state.items.length
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            )
          : NotificationCard(notification: widget.state.items[index]),
    ),
  );
}
