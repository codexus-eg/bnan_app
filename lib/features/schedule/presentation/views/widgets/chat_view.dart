import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/schedule/presentation/views/widgets/chat_widgets/chat_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: ColorManager.mainColor14,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(resizeToAvoidBottomInset: false, body: const ChatBody()),
    );
  }
}
