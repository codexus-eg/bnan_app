part of 'chat_input_bar.dart';

extension on _ChatInputBarState {
  Future<void> handleVoiceRecording() async {
    if (isSendingMessage()) return;

    if (isRecording) {
      await stopAndSendVoice();
    } else {
      await startVoiceRecording();
    }
  }

  Future<void> startVoiceRecording() async {
    try {
      final hasPermission = await audioRecorder.hasPermission();

      if (!mounted) return;

      if (!hasPermission) {
        showErrorMessage('يجب السماح باستخدام الميكروفون لتسجيل رسالة صوتية');
        return;
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/voice_$timestamp.m4a';

      await audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      if (!mounted) return;

      setRecordingStarted(filePath);

      startRecordingTimer();
    } catch (_) {
      recordingTimer?.cancel();

      if (!mounted) return;

      resetRecordingState();

      showErrorMessage('تعذر بدء تسجيل الرسالة الصوتية');
    }
  }

  void startRecordingTimer() {
    recordingTimer?.cancel();

    recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        incrementRecordingDuration();
      }
    });
  }
}
