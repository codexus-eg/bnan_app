import 'package:just_audio/just_audio.dart';

abstract interface class ChatAudioPlayerController {
  Stream<Duration> get positionStream;
  Stream<PlayerState> get playerStateStream;
  Future<Duration?> setUrl(String url, Map<String, String> headers);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> dispose();
}

class JustAudioPlayerController implements ChatAudioPlayerController {
  JustAudioPlayerController()
    : _player = AudioPlayer(useProxyForRequestHeaders: false);

  final AudioPlayer _player;

  @override
  Stream<Duration> get positionStream => _player.positionStream;
  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  @override
  Future<Duration?> setUrl(String url, Map<String, String> headers) =>
      _player.setUrl(url, headers: headers);
  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> dispose() => _player.dispose();
}
