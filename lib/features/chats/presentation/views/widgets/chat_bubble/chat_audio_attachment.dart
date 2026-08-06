import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ChatAudioAttachment extends StatefulWidget {
  const ChatAudioAttachment({
    super.key,
    required this.attachment,
    required this.isMe,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;

  @override
  State<ChatAudioAttachment> createState() => _ChatAudioAttachmentState();
}

class _ChatAudioAttachmentState extends State<ChatAudioAttachment> {
  final AudioPlayer _player = AudioPlayer();

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final duration = await _player.setUrl(widget.attachment.fileUrl);

      _duration = duration ?? Duration.zero;

      _player.positionStream.listen((position) {
        if (!mounted) return;

        setState(() {
          _position = position;
        });
      });

      _player.playerStateStream.listen((state) {
        if (!mounted) return;

        setState(() {
          _isPlaying = state.playing;
        });

        if (state.processingState == ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.pause();
        }
      });

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });
    } catch (error) {
      debugPrint('AUDIO PLAYER ERROR: $error');
      debugPrint('AUDIO URL: ${widget.attachment.fileUrl}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = widget.isMe
        ? ColorManager.white
        : ColorManager.mainColor14;

    return Row(
      children: [
        IconButton(
          onPressed: _isInitialized ? _togglePlay : null,
          icon: Icon(
            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: foregroundColor,
          ),
        ),
        Expanded(
          child: Slider(
            value: _sliderValue,
            max: _sliderMax,
            onChanged: _isInitialized
                ? (value) {
                    _player.seek(Duration(milliseconds: value.toInt()));
                  }
                : null,
          ),
        ),
        Text(
          _formatDuration(_position),
          style: TextStyle(color: foregroundColor, fontSize: 11),
        ),
      ],
    );
  }

  double get _sliderValue {
    if (_duration == Duration.zero) return 0;

    return _position.inMilliseconds
        .clamp(0, _duration.inMilliseconds)
        .toDouble();
  }

  double get _sliderMax {
    if (_duration.inMilliseconds <= 0) return 1;

    return _duration.inMilliseconds.toDouble();
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
