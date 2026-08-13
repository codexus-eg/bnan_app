part of 'chat_input_bar.dart';

extension on _ChatInputBarState {
  Future<void> stopAndSendVoice() async {
    try {
      recordingTimer?.cancel();
      final voicePath = await audioRecorder.stop();

      if (!mounted) return;

      if (voicePath == null || voicePath.isEmpty) {
        resetRecordingState();
        showErrorMessage('تعذر حفظ الرسالة الصوتية');
        return;
      }

      final voiceFile = File(voicePath);
      addSelectedFiles([
        PlatformFile(
          name: voiceFile.uri.pathSegments.last,
          path: voicePath,
          size: await voiceFile.length(),
        ),
      ]);
      resetRecordingState();
      currentVoicePath = null;
      clearTextAfterSuccess = false;
      await sendMessage();
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
}
