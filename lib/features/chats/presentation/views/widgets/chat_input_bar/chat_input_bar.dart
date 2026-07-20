library chat_input_bar;

import 'dart:async';
import 'dart:io';

import 'package:bnan_app/core/utils/assets.dart';
import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_cubit.dart';
import 'package:bnan_app/features/chats/presentation/manager/send_message_cubit/send_message_state.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_circle_button.dart';
import 'package:bnan_app/features/chats/presentation/views/widgets/chat_widgets/chat_message_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

part 'chat_input_message_actions.dart';
part 'chat_input_voice_start.dart';
part 'chat_input_voice_stop.dart';
part 'chat_input_build.dart';
part 'chat_selected_files_preview.dart';
part 'chat_selected_file_item.dart';
part 'chat_recording_widget.dart';
part 'chat_input_helpers.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.roomId,
  });

  final String roomId;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final messageController = TextEditingController();
  final audioRecorder = AudioRecorder();
  final List<PlatformFile> selectedFiles = [];

  bool isRecording = false;
  bool clearTextAfterSuccess = false;
  String? currentVoicePath;

  Timer? recordingTimer;
  Duration recordingDuration = Duration.zero;

  @override
  void dispose() {
    recordingTimer?.cancel();
    messageController.dispose();
    audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildChatInputBar(context);
  }
}