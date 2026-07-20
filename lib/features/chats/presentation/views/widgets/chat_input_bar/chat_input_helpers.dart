part of 'chat_input_bar.dart';

extension ChatInputHelpers on _ChatInputBarState {
  bool isSendingMessage() {
    return context.read<SendMessageCubit>().state
        is SendMessageLoading;
  }

  void removeSelectedFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  void handleSubmitted(String value) {
    sendMessage();
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  bool isImageFile(PlatformFile file) {
    final extension = file.extension?.toLowerCase();

    return extension == 'jpg' ||
        extension == 'jpeg' ||
        extension == 'png' ||
        extension == 'webp' ||
        extension == 'gif';
  }

  String formatRecordingDuration() {
    final minutes = recordingDuration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = recordingDuration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }
}