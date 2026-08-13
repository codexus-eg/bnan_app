part of 'chat_input_bar.dart';

extension on _ChatInputBarState {
  Widget buildChatInputBar(BuildContext context) {
    return BlocConsumer<SendMessageCubit, SendMessageState>(
      listener: handleState,
      builder: (context, state) {
        final isLoading = state is SendMessageLoading;

        return Container(
          padding: buildPadding(context),
          decoration: buildDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isRecording)
                _ChatSelectedFilesPreview(
                  files: selectedFiles,
                  isImageFile: isImageFile,
                  onRemove: removeSelectedFile,
                ),
              buildActionsRow(isLoading),
            ],
          ),
        );
      },
    );
  }

  void handleState(BuildContext context, SendMessageState state) {
    if (state is SendMessageSuccess) {
      context.read<GetRoomMessagesCubit>().addConfirmedMessage(state.message);
      handleSendSuccess();
    }

    if (state is SendMessageFailure) {
      clearTextAfterSuccess = false;
      showErrorMessage(state.errorMessage);
      context.read<SendMessageCubit>().resetState();
    }
  }

  EdgeInsetsGeometry buildPadding(BuildContext context) {
    return const EdgeInsetsDirectional.fromSTEB(8, 12, 9, 12);
  }

  BoxDecoration buildDecoration() {
    return BoxDecoration(
      color: ColorManager.white,
      boxShadow: [
        BoxShadow(
          color: ColorManager.black.withAlpha(64),
          blurRadius: 4,
          offset: const Offset(4, 0),
        ),
      ],
    );
  }
}

extension on _ChatInputBarState {
  Widget buildActionsRow(bool isLoading) {
    return Row(
      children: [
        if (!isRecording) ...[
          ChatCircleButton(
            icon: ImageManager.attachmentLineIcon,
            onTap: isLoading ? () {} : pickFiles,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ChatMessageField(
              controller: messageController,
              enabled: !isLoading,
              onSubmitted: handleSubmitted,
            ),
          ),
          const SizedBox(width: 12),
        ] else ...[
          _ChatRecordingWidget(
            duration: formatRecordingDuration(),
            onCancel: cancelVoiceRecording,
          ),
          const SizedBox(width: 12),
        ],
        ChatCircleButton(
          icon: ImageManager.microphoneIcon,
          isDark: true,
          onTap: isLoading ? () {} : handleVoiceRecording,
        ),
        if (!isRecording) ...[
          const SizedBox(width: 8),
          ChatCircleButton(
            icon: ImageManager.tablerSendIcon,
            isDark: true,
            isLoading: isLoading,
            onTap: isLoading ? () {} : sendMessage,
          ),
        ],
      ],
    );
  }
}
