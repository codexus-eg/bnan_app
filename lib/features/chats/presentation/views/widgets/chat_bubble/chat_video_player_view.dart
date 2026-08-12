import 'package:bnan_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef ChatVideoControllerLoader =
    Future<VideoPlayerController> Function(
      Uri uri,
      Map<String, String> headers,
    );

class ChatVideoPlayerView extends StatefulWidget {
  const ChatVideoPlayerView({
    super.key,
    required this.videoUrl,
    this.headers = const {},
    this.controllerLoader,
  });

  final String videoUrl;
  final Map<String, String> headers;
  final ChatVideoControllerLoader? controllerLoader;

  @override
  State<ChatVideoPlayerView> createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  VideoPlayerController? _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null ||
        uri.host.isEmpty ||
        !uri.isScheme('http') && !uri.isScheme('https')) {
      if (mounted) setState(() => _hasError = true);
      return;
    }
    try {
      final loader = widget.controllerLoader ?? _loadController;
      final controller = await loader(uri, widget.headers);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } catch (_) {
      if (mounted) setState(() => _hasError = true);
    }
  }

  Future<VideoPlayerController> _loadController(
    Uri uri,
    Map<String, String> headers,
  ) async {
    final controller = VideoPlayerController.networkUrl(
      uri,
      httpHeaders: headers,
    );
    try {
      await controller.initialize();
      return controller;
    } catch (_) {
      await controller.dispose();
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: _hasError
            ? Text(
                S.of(context).unableToLoadAttachment,
                style: const TextStyle(color: Colors.white),
              )
            : controller == null
            ? const CircularProgressIndicator(color: Colors.white)
            : AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(controller),
                    IconButton(
                      onPressed: _togglePlay,
                      iconSize: 60,
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _togglePlay() async {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
