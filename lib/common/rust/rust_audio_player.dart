export 'api/audio_api.dart' show AudioPlaybackState;
import 'api/audio_api.dart';

class RustAudioPlayer {
  String? _currentSourcePath;
  double _volume = 1.0;

  String? get currentSourcePath => _currentSourcePath;
  double get volume => _volume;

  Future<AudioPlaybackState> playFile(
    String path, {
    Duration position = Duration.zero,
  }) async {
    final state = await audioPlayFile(
      path: path,
      positionMs: position.inMilliseconds,
    );
    _sync(state);
    return state;
  }

  Future<AudioPlaybackState> pause() async {
    final state = await audioPause();
    _sync(state);
    return state;
  }

  Future<AudioPlaybackState> resume() async {
    final state = await audioResume();
    _sync(state);
    return state;
  }

  Future<AudioPlaybackState> seek(Duration position) async {
    final state = await audioSeek(positionMs: position.inMilliseconds);
    _sync(state);
    return state;
  }

  Future<AudioPlaybackState> setVolume(double volume) async {
    final state = await audioSetVolume(volume: volume);
    _sync(state);
    return state;
  }

  Future<AudioPlaybackState> refresh() async {
    final state = await audioGetState();
    _sync(state);
    return state;
  }

  Future<void> dispose() async {
    await audioDispose();
    _currentSourcePath = null;
  }

  void _sync(AudioPlaybackState state) {
    _currentSourcePath = state.currentSourcePath;
    _volume = state.volume;
  }
}
