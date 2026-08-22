import 'package:bnan_app/core/network/dependency_injection.dart';
import 'package:bnan_app/features/chats/presentation/manager/get_chat_rooms_cubit/get_chat_rooms_cubit.dart';
import 'package:bnan_app/features/chats/presentation/views/groups_view.dart';
import 'package:bnan_app/features/shared_profile/presentation/views/bodies/teacher_profile_body.dart';
import 'package:bnan_app/features/teacher_assignment/presentation/views/teacher_asignment_view.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_home_page.dart';
import 'package:bnan_app/features/teacher_home/presentation/views/widgets/teacher_home_widgets/teacher_certificates_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherHomeContent extends StatelessWidget {
  const TeacherHomeContent({
    super.key,
    required this.index,
    required this.onMenuTap,
  });

  final int index;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    final pages = [
      TeacherHomePage(onMenuTap: onMenuTap),
      TeacherAssignmentsView(),
      BlocProvider(
        create: (_) => getIt<GetChatRoomsCubit>()..getChatRooms(),
        child: const GroupsView(showBackButton: false),
      ),
      const TeacherCertificatesTab(),
      const TeacherProfileBody(),
    ];

    return pages[index];
  }
}
