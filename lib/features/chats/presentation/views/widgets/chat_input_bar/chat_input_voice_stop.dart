part of 'chat_input_bar.dart';

extension ChatInputVoiceStop on _ChatInputBarState {
  Future<void> stopAndSendVoice() async {
    try {
      recordingTimer?.cancel();
      final voicePath = await audioRecorder.stop();

      if (!mounted) return;

      resetRecordingState();
      currentVoicePath = null;

      if (voicePath == null || voicePath.isEmpty) {
        showErrorMessage('تعذر حفظ الرسالة الصوتية');
        return;
      }

      clearTextAfterSuccess = false;

      await context.read<SendMessageCubit>().sendVoice(
            roomId: widget.roomId,
            voicePath: voicePath,
          );
    } catch (_) {
      recordingTimer?.cancel();

      if (!mounted) return;

      resetRecordingState();
      showErrorMessage('حدث خطأ أثناء حفظ الرسالة الصوتية');
    }
  }

  Future<void> cancelVoiceRecording() async {
    try {
      recordingTimer?.cancel();

      final stoppedPath = await audioRecorder.stop();
      final pathToDelete = stoppedPath ?? currentVoicePath;

      if (pathToDelete != null) {
        final file = File(pathToDelete);

        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (_) {
      // تجاهل خطأ حذف الملف المؤقت.
    }

    currentVoicePath = null;

    if (mounted) {
      resetRecordingState();
    }
  }

  void resetRecordingState() {
    setState(() {
      isRecording = false;
      recordingDuration = Duration.zero;
    });
  }
}