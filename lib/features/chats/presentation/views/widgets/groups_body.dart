import 'package:bnan_app/core/app_routes/routes.dart';
import 'package:bnan_app/core/helper/my_navigator.dart';
import 'package:bnan_app/core/shared_widget/app_skeletonizer.dart';
import 'package:bnan_app/core/shared_widget/custom_chat_card.dart';
import 'package:bnan_app/core/shared_widget/no_data_widget.dart';
import 'package:bnan_app/core/session/session_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_room_summary_model.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_state.dart';
import 'package:bnan_app/features/chats/presentation/models/chat_route_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupsBody extends StatelessWidget {
  const GroupsBody({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsetsDirectional.all(16),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];

                return Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      MyNavigator.goTo(
                        context,
                        Routes.chat,
                        extra: ChatRouteArgs(
                          roomId: room.id,
                          roomType: room.type,
                          classroomId: room.classroomId,
                          classroomName: room.displayName,
                          currentUserRole: SessionManager.instance.userRole,
                        ),
                      );
                    },
                    child: CustomChatCard(
                      title: room.displayName,
                      subtitle: room.subtitle,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
