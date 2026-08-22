import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/members/classroom_members_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ClassroomMembersView extends StatelessWidget {
  const ClassroomMembersView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppbar(headerText: S.of(context).students),
    body: const SafeArea(child: ClassroomMembersBody()),
  );
}
