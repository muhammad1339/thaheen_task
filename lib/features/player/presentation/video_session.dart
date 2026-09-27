import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

/// One lesson's video: playback control for [PlayerCubit] and a view for the
/// UI, so neither depends on the concrete player package.
abstract class VideoSession extends ChangeNotifier {
  Duration get position;
  Duration get duration;
  bool get playing;
  String? get error;

  /// Width ÷ height once known; null before the video is initialized.
  double? get aspectRatio;

  Future<void> initialize();
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> setSpeed(double speed);
  Future<void> release();

  /// The video surface with [controls] drawn over it.
  Widget buildView({required Widget controls});
}

/// [VideoSession] backed by `video_player`, displayed through Chewie.
class NativeVideoSession extends VideoSession {
  NativeVideoSession(String asset)
    : _controller = VideoPlayerController.asset(asset) {
    _controller.addListener(notifyListeners);
  }

  final VideoPlayerController _controller;
  ChewieController? _chewie;

  @override
  Duration get position => _controller.value.position;
  @override
  Duration get duration => _controller.value.duration;
  @override
  bool get playing => _controller.value.isPlaying;
  @override
  String? get error => _controller.value.errorDescription;
  @override
  double? get aspectRatio {
    final ratio = _controller.value.aspectRatio;
    return _controller.value.isInitialized && ratio > 0 ? ratio : null;
  }

  @override
  Future<void> initialize() => _controller.initialize();
  @override
  Future<void> play() => _controller.play();
  @override
  Future<void> pause() => _controller.pause();
  @override
  Future<void> seek(Duration position) => _controller.seekTo(position);
  @override
  Future<void> setSpeed(double speed) => _controller.setPlaybackSpeed(speed);

  @override
  Widget buildView({required Widget controls}) {
    // Created once and reused, so rebuilds and fullscreen share one Chewie.
    final chewie = _chewie ??= ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      showOptions: false,
      allowPlaybackSpeedChanging: false,
      customControls: controls,
      deviceOrientationsOnEnterFullScreen: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: DeviceOrientation.values,
      systemOverlaysAfterFullScreen: SystemUiOverlay.values,
    );
    return Chewie(controller: chewie);
  }

  @override
  Future<void> release() async {
    _controller.removeListener(notifyListeners);
    _chewie?.dispose();
    _chewie = null;
    await _controller.dispose();
    dispose();
  }
}
