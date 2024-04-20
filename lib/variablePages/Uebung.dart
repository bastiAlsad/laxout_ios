// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/hive_communication.dart';

// ignore: must_be_immutable
class Uebung extends StatefulWidget {
  final int exerciseListLength;
  final int currentIndex;
  final String ausfuehrung;
  final String nameUebung;
  final VoidCallback onForwardPressed;
  final VoidCallback onBackwardPressed;
  final int dauer;
  final String? videoPath;
  final bool looping;
  final bool timer;

  const Uebung({
    Key? key,
    required this.exerciseListLength,
    required this.currentIndex,
    required this.ausfuehrung,
    required this.nameUebung,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    required this.dauer,
    required this.videoPath,
    required this.looping,
    required this.timer,
  }) : super(key: key);

  @override
  State<Uebung> createState() => _UebungState();
}

class _UebungState extends State<Uebung> with SingleTickerProviderStateMixin {
  final HiveDatabase _hiveCredit = HiveDatabase();
  int actualControlltime = 0;

  @override
  void initState() {
    _hiveCredit.clearControllTime();
    actualControlltime = widget.dauer;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    timeleft = widget.dauer;
    toPercent = widget.dauer;
    super.initState();
  }

  int timeleft = 10;
  int toPercent = 10;
  double timerWidth = 200;
  bool startvisible = true;
  bool stopvisible = false;
  bool stoppressed = false;
  bool againpressed = false;
  late AnimationController _animationController;

bool isTimerRunning = false;

void timer() {
  if (!isTimerRunning) {
    isTimerRunning = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeleft > 0 && !stoppressed) {
          timeleft--;
        } else {
          timer.cancel();
          isTimerRunning = false;
          if (!stoppressed) {
            actualControlltime = widget.dauer; 
            _hiveCredit.putControllTime(actualControlltime);
            _hiveCredit.addGenerallControllTime(actualControlltime);
            widget.onForwardPressed();
          }

          if (timeleft == 0 || againpressed) {
            againpressed = false;
            stopvisible = false;
            startvisible = true;
            timeleft = widget.dauer;
            isTimerRunning = false; // Setze den Timer auf nicht gestartet zurück
            return; // Verlasse die Timer-Funktion, um mehrere Timer-Instanzen zu vermeiden
          }
        }
      });
    });
  }
}


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if(orientation == Orientation.landscape){
        return VideoWidget(looping: widget.looping, videoData: widget.videoPath!);
      }
      else{
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
            height: MediaQuery.of(context).size.height / 2.5,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: OnlineVideoPlayer(videoPath: widget.videoPath!, looping: widget.looping,)),
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
                                    const Color.fromRGBO(176, 224, 230, 1.0),
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
                                        setState(() {
                                          startvisible = false;
                                        stopvisible = true;
                                        stoppressed = false;
                                        });
                                        timer();
                                        
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
                                        setState(() {
                                          startvisible = true;
                                        stopvisible = false;
                                        stoppressed = true;
                                        });
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
                          const Expanded(child: SizedBox()),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              
                              IconButton(
                                  onPressed: widget.onBackwardPressed,
                                  icon: const Icon(Icons.arrow_back_ios,
                                      size: 40)),
                              Text(
                                "${widget.dauer.toString()}X",
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
                           Expanded(child: SizedBox(child: IconButton(
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
                                    )),)),
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
                                SizedBox(),
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
    });
  }
}

class VideoWidget extends StatefulWidget {
  final bool looping;
  final String videoData;

  const VideoWidget(
      {super.key, required this.looping, required this.videoData});

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late YoutubePlayerController _controller;

  void listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      // Das Video wurde beendet. Hier kannst du Aktionen ausführen.
      // Zum Beispiel das Video auf den Anfang setzen und pausieren:
      if (_controller.value.position != const Duration(seconds: 0)) {
        _controller.seekTo(const Duration(seconds: 0));
        widget.looping == true ? _controller.play(): _controller.pause();
      }
    } else if (_controller.value.playerState == PlayerState.playing) {
      // Das Video wird abgespielt. Hier kannst du Aktionen ausführen, wenn es abgespielt wird.
    } else if (_controller.value.playerState == PlayerState.paused) {
      // Das Video wurde pausiert. Hier kannst du Aktionen ausführen, wenn es pausiert ist.
    }
  }
  bool showError = true;
  bool playVisible = false;
  @override
  void initState() {
    super.initState();
    String? videoId = YoutubePlayer.convertUrlToId(widget.videoData);

    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          loop: widget.looping,
          mute: true,
          hideControls: false,
        ),
      );

      _controller.addListener(listener);
      showError = false;
    } else {
      showError = true;
      print("Fehler beim Extrahieren der Video-ID");
      print("Video Path ${widget.videoData}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return showError == true ? SpinKitFadingFour(color: Appcolors.primary,):Stack(
      alignment: Alignment.center,
      children: [
        YoutubePlayer(
          aspectRatio: 4 / 3,
          controller: _controller,
          showVideoProgressIndicator: false,
          onEnded: (metaData) {
            _controller.pause();
            widget.looping == false ?setState(() {
              playVisible = true;
            }):(){};
          },

          controlsTimeOut: Duration(
              seconds: 4), // Zeit, bis die Bedienelemente ausgeblendet werden
          onReady: () {
            // Hier kannst du zusätzliche Anpassungen vornehmen, wenn das Video bereit ist.
            _controller.play();
          },
        ),
        Visibility(
                visible: playVisible,
                child: IconButton(
                  icon: Icon(
                    Icons.repeat,
                    size: 45,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      playVisible = false;
                    });
                    _controller.seekTo(Duration.zero);
                    _controller.play();
                  },
                ),
              ),
      ],
    );
  }
}

//

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




class OnlineVideoPlayer extends StatefulWidget {
  final bool looping;
  final String videoPath;

  const OnlineVideoPlayer({Key? key, required this.looping, required this.videoPath})
      : super(key: key);

  @override
  _OnlineVideoPlayerState createState() => _OnlineVideoPlayerState();
}

class _OnlineVideoPlayerState extends State<OnlineVideoPlayer> {
  late VideoPlayerController _controller;
  bool showRepeatButton = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://dashboardlaxout.eu.pythonanywhere.com/static/${widget.videoPath}'),
      
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(_videoListener);
    _controller.setVolume(0);
    _controller.setLooping(widget.looping);
    _controller.initialize().then((_) {
      _controller.play();
    });
  }

  void _videoListener() {
    if (!mounted) return;
    if (_controller.value.isPlaying && showRepeatButton) {
      setState(() {
        showRepeatButton = false;
      });
    } else if (!_controller.value.isPlaying && !showRepeatButton && !widget.looping) {
      setState(() {
        _controller.seekTo(Duration.zero);
        showRepeatButton = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(_controller),
        if (showRepeatButton)
          GestureDetector(
            onTap: () {
              setState(() {
                showRepeatButton = false;
                _controller.seekTo(Duration.zero);
                _controller.play();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(16),
              child: Icon(Icons.repeat, size: 40, color: Colors.black),
            ),
          ),
      ],
    );
  }
}
