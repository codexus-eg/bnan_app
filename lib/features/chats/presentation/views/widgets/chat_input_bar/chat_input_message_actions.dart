part of 'chat_input_bar.dart';

extension on _ChatInputBarState {
  Future<void> sendMessage() async {
    if (isSendingMessage() || isRecording) return;

    final text = messageController.text.trim();
    final paths = selectedFiles
        .where((file) => file.path != null)
        .map((file) => file.path!)
        .toList();

    if (text.isEmpty && paths.isEmpty) return;

    clearTextAfterSuccess = text.isNotEmpty;

    if (paths.isNotEmpty) {
      await context.read<SendMessageCubit>().sendFiles(
        roomId: widget.roomId,
        filePaths: paths,
        text: text.isEmpty ? null : text,
      );
      return;
    }

    await context.read<SendMessageCubit>().sendTextMessage(
      roomId: widget.roomId,
      text: text,
    );
  }

  Future<void> pickFiles() async {
    if (isSendingMessage() || isRecording) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (!mounted || result == null) return;

      final files = result.files.where((file) => file.path != null).toList();

      if (files.isEmpty) {
        showErrorMessage('تعذر الوصول إلى الملفات المختارة');
        return;
      }

      addSelectedFiles(files);
    } catch (_) {
      if (mounted) {
        showErrorMessage('حدث خطأ أثناء اختيار الملفات');
      }
    }
  }
}
