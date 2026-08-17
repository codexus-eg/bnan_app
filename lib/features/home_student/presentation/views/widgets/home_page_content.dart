import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/student_profile_body.dart';
import 'package:bnan_app/features/student_assignments_and_certificate/presentation/views/widgets/assignments/assignments_body.dart';
import 'package:bnan_app/features/home_student/presentation/views/widgets/student_home_page/student_home_page.dart';
import 'package:bnan_app/features/student_schedule/presentation/widgets/schedule_widgets/schedule_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({
    super.key,
    required this.index,
    required this.onMenuTap,
    required this.userName,
  });

  final int index;
  final VoidCallback onMenuTap;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final pages = [
      StudentHomePage(onMenuTap: onMenuTap, userName: userName),
      const ScheduleBody(),
      AssignmentsBody(),
      BlocProvider(
        create: (_) => getIt<GetChatRoomsCubit>()..getChatRooms(),
        child: const GroupsView(showBackButton: false),
      ),
      StudentProfileBody(),
    ];

    return pages[index];
  }
}
