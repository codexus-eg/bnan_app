import 'dart:async';

import 'package:bnan_app/core/utils/color_manager.dart';
import 'package:bnan_app/features/chats/data/models/chat_attachment_model.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_attachment_url.dart';
import 'package:bnan_app/features/chats/presentation/utils/chat_audio_playback_coordinator.dart';
import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ChatAudioAttachment extends StatefulWidget {
  const ChatAudioAttachment({
    super.key,
    required this.attachment,
    required this.isMe,
    this.coordinator,
  });

  final ChatAttachmentModel attachment;
  final bool isMe;
  final ChatAudioPlaybackCoordinator? coordinator;

  @override
  State<ChatAudioAttachment> createState() => _ChatAudioAttachmentState();
}

class _ChatAudioAttachmentState extends State<ChatAudioAttachment> {
  final AudioPlayer _player = AudioPlayer();
  late final ChatAudioPlaybackCoordinator _coordinator;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _coordinator = widget.coordinator ?? chatAudioPlaybackCoordinator;
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final uri = ChatAttachmentUrl.resolve(widget.attachment.fileUrl);
    if (uri == null) {
      _hasError = true;
      return;
    }
    try {
      _duration =
          await _player.setUrl(
            uri.toString(),
            headers: ChatAttachmentUrl.headersFor(uri),
          ) ??
          Duration.zero;
      _positionSubscription = _player.positionStream.listen(_onPosition);
      _stateSubscription = _player.playerStateStream.listen(_onPlayerState);
      if (mounted) setState(() => _isInitialized = true);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  void _onPosition(Duration position) {
    if (mounted) setState(() => _position = position);
  }

  void _onPlayerState(PlayerState state) {
    if (!mounted) return;
    setState(() => _isPlaying = state.playing);
    if (state.processingState == ProcessingState.completed) {
      _coordinator.release(this);
      _player.seek(Duration.zero);
      _player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isMe ? ColorManager.white : ColorManager.mainColor14;
    if (_hasError) {
      return Row(
        children: [
          Icon(Icons.error_outline, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.of(context).unableToLoadAttachment,
              style: TextStyle(color: color, fontSize: 11),
            ),
          ),
        ],
      );
    }
    return Row(
      children: [
        IconButton(
          onPressed: _isInitialized ? _togglePlay : null,
          icon: Icon(
            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: color,
          ),
        ),
        Expanded(
          child: Slider(
            value: _sliderValue,
            max: _sliderMax,
            onChanged: _isInitialized ? _seek : null,
          ),
        ),
        Text(
          _formatDuration(_position),
          style: TextStyle(color: color, fontSize: 11),
        ),
      ],
    );
  }

  void _seek(double value) =>
      _player.seek(Duration(milliseconds: value.toInt()));

  double get _sliderValue => _duration == Duration.zero
      ? 0
      : _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble();

  double get _sliderMax =>
      _duration.inMilliseconds <= 0 ? 1 : _duration.inMilliseconds.toDouble();

  Future<void> _togglePlay() async {
    try {
      if (_isPlaying) {
        await _player.pause();
        _coordinator.release(this);
      } else {
        await _coordinator.activate(this, _player.pause);
        await _player.play();
      }
    } catch (_) {
      _coordinator.release(this);
      if (mounted) setState(() => _hasError = true);
    }
  }

  String _formatDuration(Duration value) {
    return '${value.inMinutes}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _coordinator.release(this);
    unawaited(_positionSubscription?.cancel());
    unawaited(_stateSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }
}
