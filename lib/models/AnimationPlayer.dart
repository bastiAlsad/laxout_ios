
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AnimationPlayer extends StatefulWidget {
  final bool looping;
  final videoData;
  const AnimationPlayer({Key? key, required this.videoData, required this.looping})
      : super(key: key);

  static _AnimationPlayerState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AnimationPlayerState>();

  @override
  _AnimationPlayerState createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant AnimationPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoData != oldWidget.videoData) {
      // Video-Pfad hat sich geändert, Controller aktualisieren
      _controller.dispose();
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset(widget.videoData)
      ..addListener(() => setState(() {}))
      ..setLooping(widget.looping);

    try {
      await _controller.initialize();
      _controller.play();
      // ignore: empty_catches
    } catch (error) {}
  }

  void play() {
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.isInitialized) {
      return SizedBox(
        width: 200,
       
        child: VideoPlayer(_controller),
      );
    } else {
      return const Center(
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
