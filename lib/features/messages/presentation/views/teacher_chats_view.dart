import 'package:bnan_app/core/shared_widget/custom_appbar.dart';
import 'package:bnan_app/features/messages/presentation/views/widgets/messages_body.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class TeacherChatsView extends StatelessWidget {
  const TeacherChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        headerText: S.of(context).groups,
        iconNeeded: true,
      ),
      body: MessagesBody(),
    );
  }
}
