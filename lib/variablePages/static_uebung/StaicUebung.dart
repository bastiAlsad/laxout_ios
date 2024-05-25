// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/hive_communication.dart';

// ignore: must_be_immutable
class StaticUebung extends StatefulWidget {
  final int exerciseListLength;
  final int currentIndex;
  final String ausfuehrung;
  final String nameUebung;
  final VoidCallback onForwardPressed;
  final VoidCallback onBackwardPressed;
  final int dauer;
  String videoPath;
  final bool looping;
  final bool timer;

  StaticUebung({
    Key? key,
    required this.ausfuehrung,
    required this.nameUebung,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    required this.dauer,
    this.videoPath = "",
    required this.looping,
    required this.timer, required this.exerciseListLength, required this.currentIndex,
  }) : super(key: key);

  @override
  State<StaticUebung> createState() => _StaticUebungState();
}

class _StaticUebungState extends State<StaticUebung> with SingleTickerProviderStateMixin {
  final HiveDatabase _hiveCredit = HiveDatabase();
  int actualControlltime = 0;
  late Key _videoKey; // Neuer Key für das LoopingVideo
  @override
  void initState() {
    _videoKey = UniqueKey();
     actualControlltime = widget
              .dauer;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    timeleft = widget.dauer;
    toPercent = widget.dauer;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StaticUebung oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      _videoKey =
          UniqueKey(); // Aktualisierung des Keys, wenn sich der Video-Pfad ändert
    }
  }

  int timeleft = 10;
  int toPercent = 10;
  double timerWidth = 200;
  bool startvisible = true;
  bool stopvisible = false;
  bool stoppressed = false;
  bool againpressed = false;
  late AnimationController _animationController;

  void timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeleft > 0 && stoppressed == false) {
          timeleft--;
        } else {
          timer.cancel();

          actualControlltime = widget
              .dauer; // Alte version _hiveCredit.getControlltime() + widget.dauer;
          _hiveCredit.putControllTime(actualControlltime);
          _hiveCredit.addGenerallControllTime(actualControlltime);
          widget.onForwardPressed();

          if (timeleft == 0 || againpressed == true) {
            againpressed = false;
            stopvisible = false;
            startvisible = true;
            timeleft = widget.dauer;
            timer;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.nameUebung,
          style: const TextStyle(color: Colors.black),
        ),
        bottomOpacity: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.1,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: VideoWidget(
                key:
                    _videoKey, // Verwendung des eindeutigen Keys für das LoopingVideo
                videoData: widget.videoPath,
                looping: widget.looping,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: widget.timer
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Fortschritt:",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: "Laxout"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 30, top: 5, right: 10),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade100,
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(20),
                             
                              value: widget.currentIndex /
                                  widget.exerciseListLength,
                              semanticsLabel: 'Linear progress indicator',
                              minHeight: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: widget.onBackwardPressed,
                                  icon: const Icon(Icons.arrow_back_ios,
                                      size: 40)),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    timeleft = timeleft + 5;
                                    toPercent = toPercent + 5;
                                  });
                                },
                                child: Container(
                                  width: 45,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                      child: Text(
                                    "+5Sek.",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                              CircularPercentIndicator(
                                radius: 55,
                                percent: (timeleft / toPercent).toDouble(),
                                animation: true,
                                animationDuration: 1000,
                                animateFromLastPercent: true,
                                lineWidth: 10,
                                progressColor:
                                    Appcolors.primary,
                                backgroundColor: Colors.white,
                                center: Text(
                                  timeleft.toString(),
                                  style: const TextStyle(
                                      fontSize: 30, color: Colors.black),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (timeleft > 30) {
                                      timeleft = timeleft - 5;
                                      toPercent = toPercent - 5;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 45,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Center(
                                      child: Text("-5Sek.",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                ),
                              ),
                              IconButton(
                                  onPressed: widget.onForwardPressed,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 40,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog<AlertDialog>(
                                      barrierColor: Colors.white.withOpacity(0),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))),
                                            content: Text(
                                              "Ausführung:\n${widget.ausfuehrung}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ));
                                      });
                                },
                                icon: const Icon(
                                  Icons.lightbulb,
                                  size: 25,
                                ),
                              ),
                              Stack(
                                children: [
                                  Visibility(
                                    visible: startvisible,
                                    child: InkWell(
                                      onTap: () {
                                        timer();
                                        startvisible = false;
                                        stopvisible = true;
                                        stoppressed = false;
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                  offset: Offset(5, 0),
                                                  blurRadius: 20,
                                                  color: Colors.black12)
                                            ]),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.play_arrow_sharp,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Start",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: stopvisible,
                                    child: InkWell(
                                      onTap: () {
                                        timer();
                                        startvisible = true;
                                        stopvisible = false;
                                        stoppressed = true;
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                  offset: Offset(5, 0),
                                                  blurRadius: 20,
                                                  color: Colors.black12)
                                            ]),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.stop,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Stop",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyBottomNavigationBar(startindex: 0,)),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.home,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Fortschritt:",
                                style: TextStyle(
                                    fontSize: 14, fontFamily: "Laxout"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 30, top: 5, right: 10),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade100,
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(20),
                             
                              value: widget.currentIndex /
                                  widget.exerciseListLength,
                              semanticsLabel: 'Linear progress indicator',
                              minHeight: 20,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: widget.onBackwardPressed,
                                  icon: const Icon(Icons.arrow_back_ios,
                                      size: 40)),
                              Text(
                                widget.dauer.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 45,
                                    fontFamily: "Laxout"),
                              ),
                              IconButton(
                                  onPressed: widget.onForwardPressed,
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 40,
                                  )),
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog<AlertDialog>(
                                        barrierColor:
                                            Colors.white.withOpacity(0),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              backgroundColor: Colors.white,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0))),
                                              content: Text(
                                                "Ausführung:\n${widget.ausfuehrung}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                              ));
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.lightbulb,
                                    size: 25,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _hiveCredit
                                          .putControllTime(actualControlltime);
                                      _hiveCredit.addGenerallControllTime(
                                          actualControlltime);
                                      widget.onForwardPressed();
                                      
                                    },
                                    icon: Icon(
                                      Icons.done,
                                      color: Appcolors.primary,
                                      size: 45,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyBottomNavigationBar(startindex: 0,)),
                                        (route) => false);
                                  },
                                  icon: const Icon(
                                    Icons.home,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          )

          
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final bool looping;
  // ignore: prefer_typing_uninitialized_variables
  final videoData;

  const VideoWidget(
      {required Key key, required this.looping, required this.videoData})
      : super(key: key);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  late Widget videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controller = VideoPlayerController.asset(widget.videoData)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(const Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller.play();
        });
      });

    // Setzen Sie die Wiederholung des Videos basierend auf der "looping" Variable.
    _controller.setLooping(widget.looping);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 16 / 9,
        child: _controller.value.isInitialized ? videoPlayer() : Container(),
      );

  Widget videoPlayer() => Stack(
        children: <Widget>[
          video(),
          Center(child: videoStatusAnimation),
        ],
      );

  Widget video() => GestureDetector(
        child: VideoPlayer(_controller),
        onTap: () {
          if (!_controller.value.isInitialized) {
            return;
          }
          if (_controller.value.isPlaying) {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.pause, size: 100.0));
            _controller.pause();
          } else {
            videoStatusAnimation =
                const FadeAnimation(child: Icon(Icons.play_arrow, size: 100.0));
            _controller.play();
          }
        },
      );
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {super.key, required this.child,
      this.duration = const Duration(milliseconds: 1000)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController.isAnimating
      ? Opacity(
          opacity: 1.0 - animationController.value,
          child: widget.child,
        )
      : Container();
}

class LoopingVideo extends StatefulWidget {
  final bool looping;
  final videoData;
  const LoopingVideo({Key? key, required this.videoData, required this.looping})
      : super(key: key);

  static _LoopingVideoState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LoopingVideoState>();

  @override
  _LoopingVideoState createState() => _LoopingVideoState();
}

class _LoopingVideoState extends State<LoopingVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void didUpdateWidget(covariant LoopingVideo oldWidget) {
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
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      );
    } else {
      return const Center(
          child: SpinKitPulsingGrid(
        color: Colors.black,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
