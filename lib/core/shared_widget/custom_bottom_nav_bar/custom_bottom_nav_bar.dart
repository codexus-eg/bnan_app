import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/bottom_nav_item_model.dart';
import 'package:bnan_app/core/shared_widget/custom_bottom_nav_bar/custom_bottom_nav_item.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<BottomNavItemModel> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (!items.any((item) => item.tracksUnreadMessages)) {
      return _bar(context, false);
    }
    final cubit = context.read<GetChatRoomsCubit?>();
    if (cubit == null) return _bar(context, false);
    return BlocSelector<GetChatRoomsCubit, GetChatRoomsState, bool>(
      bloc: cubit,
      selector: (_) => cubit.totalUnreadCount > 0,
      builder: (context, hasUnread) => _bar(context, hasUnread),
    );
  }

  Widget _bar(BuildContext context, bool hasUnread) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: 70,
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 8),
        decoration: BoxDecoration(
          color: ColorManager.greyF8F9,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withAlpha((255 * .25).round()),
              blurRadius: 4,
              offset: const Offset(4, 0),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            return Expanded(
              child: CustomBottomNavItem(
                imagePath: item.icon,
                title: item.title,
                isSelected: currentIndex == index,
                showUnreadDot: item.tracksUnreadMessages && hasUnread,
                onTap: () => onTap(index),
              ),
            );
          }),
        ),
      ),
    );
  }
}
