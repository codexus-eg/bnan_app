import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/groups_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(headerText: S.of(context).groups, iconNeeded: true),
      body: GroupsBody(),
    );
  }
}
