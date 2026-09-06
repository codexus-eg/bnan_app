import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_chat_card.dart';
import 'package:bnan_app/core/shared_widget/custom_text_field.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/enums/user_role.dart';
import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:bnan_app/features/chats/presentation/navigation/chat_room_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GroupsBody extends StatelessWidget {
  const GroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = SessionManager.instance.role == UserRole.admin;

    final canSearch = const {
      UserRole.admin,
      UserRole.supervisor,
      UserRole.teacher,
    }.contains(SessionManager.instance.role);

    return Column(
      children: [
        if (canSearch)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            child: CustomTextField(
              hintText: S.of(context).searchConversations,
              backgroundColor: ColorManager.white,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SvgPicture.asset(
                  ImageManager.usersManagementSearchIcon,
                  width: 16,
                ),
              ),
              onChanged: context.read<GetChatRoomsCubit>().searchRooms,
            ),
          ),
        Expanded(child: _rooms(context, isAdmin)),
      ],
    );
  }

  Widget _rooms(BuildContext context, bool isAdmin) {
    return BlocBuilder<GetChatRoomsCubit, GetChatRoomsState>(
      builder: (context, state) {
        if (state is GetChatRoomsFailure) {
          return Center(child: Text(state.errorMessage));
        }

        if (state is GetChatRoomsSuccess && state.rooms.isEmpty) {
          return const NoDataWidget();
        }

        final bool isLoading =
            state is GetChatRoomsInitial || state is GetChatRoomsLoading;

        final List<ChatRoomSummaryModel> rooms = state is GetChatRoomsSuccess
            ? state.rooms
            : ChatRoomSummaryModel.placeholders;

        return AppSkeletonizer(
          isLoading: isLoading,
          child: RefreshIndicator(
            onRefresh: () {
              return context.read<GetChatRoomsCubit>().getChatRooms();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.all(16),
              itemCount: rooms.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final room = rooms[index];

                return InkWell(
                  onTap: () async {
                    final path = ChatRoomNavigation.path(room);

                    if (path == null) return;

                    await MyNavigator.goTo(
                      context,
                      path,
                      extra: ChatRoomNavigation.arguments(
                        room,
                        currentUserRole: SessionManager.instance.userRole,
                      ),
                    );

                    if (!context.mounted) return;

                    await context.read<GetChatRoomsCubit>().getChatRooms();
                  },
                  child: CustomChatCard(
                    title: room.displayName,
                    subtitle: _subtitle(room),
                    unreadCount: room.unreadCount,
                    badgeText: isAdmin && room.type == 'support'
                        ? S.of(context).supportBadge
                        : null,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  String _subtitle(ChatRoomSummaryModel room) {
    final subtitle = room.subtitle.trim();

    if (subtitle.isNotEmpty) {
      return subtitle;
    }

    return 'محادثة';
  }
}
