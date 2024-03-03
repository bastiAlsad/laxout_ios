// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/models/intfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class UebungForTests extends StatefulWidget {
  final int exerciseListLength;
  final int currentIndex;
  final String ausfuehrung;
  final String nameUebung;
  final VoidCallback onForwardPressed;
  final VoidCallback onBackwardPressed;
  final String? videoPath;
  final bool looping;
  final bool timer;

  const UebungForTests({
    Key? key,
    required this.ausfuehrung,
    required this.nameUebung,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    this.videoPath = "",
    required this.looping,
    required this.timer,
    required this.exerciseListLength,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<UebungForTests> createState() => _UebungForTestsState();
}

class _UebungForTestsState extends State<UebungForTests>
    with SingleTickerProviderStateMixin {
  final HiveDatabase _hiveCredit = HiveDatabase();
  int actualControlltime = 0;
  TextEditingController controller = TextEditingController();

  int covertWH(String wh) {
    int toReturn = 0;
    toReturn = int.parse(wh);
    return toReturn;
  }

  @override
  void initState() {
    if (widget.timer == true) {}

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  int timeleft = 0;
  int toPercent = 1;
  double timerWidth = 200;
  bool startvisible = true;
  bool stopvisible = false;
  bool stoppressed = false;
  bool againpressed = false;
  bool againvisible = false;
  late AnimationController _animationController;

  String getTime() {
    return timeleft.toString();
  }

  bool isTimerRunning = false;

  void timer() {
    if (!isTimerRunning) {
      isTimerRunning = true;
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (!stoppressed) {
            timeleft++;
            toPercent++;
          } else {
            timer.cancel();
            isTimerRunning = false;
            
              timeleft > 15 ? _hiveCredit.putControllTime(30) : () {};
              
           
            if (timeleft == 0 || againpressed) {
              againpressed = false;
              stopvisible = false;
              startvisible = true;
              isTimerRunning =
                  false; // Setze den Timer auf nicht gestartet zurück
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
      if (orientation == Orientation.landscape) {
        return VideoWidgetTest(
            looping: widget.looping, videoData: widget.videoPath!);
      } else {
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: VideoWidgetTest(
                    looping: widget.looping,
                    videoData: widget.videoPath ?? "Error",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                      onPressed: widget.onBackwardPressed,
                                      icon: const Icon(Icons.arrow_back_ios,
                                          size: 40)),
                                  CircularPercentIndicator(
                                    radius: 55,
                                    percent: (1 / toPercent).toDouble(),
                                    animation: true,
                                    animationDuration: 100,
                                    animateFromLastPercent: true,
                                    lineWidth: 10,
                                    progressColor: const Color.fromRGBO(
                                        176, 224, 230, 1.0),
                                    backgroundColor: Colors.white,
                                    center: Text(
                                      timeleft.toString(),
                                      style: const TextStyle(
                                          fontSize: 30, color: Colors.black),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                            setState(() {
                                              stopvisible = false;
                                              stoppressed = true;
                                              againvisible = true;
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
                                      Visibility(
                                        visible: againvisible,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  stopvisible = false;
                                                  startvisible = true;
                                                  stoppressed = true;
                                                  againvisible = false;
                                                });
                                                timeleft = 0;
                                                toPercent = 1;
                                                _hiveCredit
                                                    .addCredits(timeleft);
                                                timer();
                                              },
                                              child: Container(
                                                width: 110,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          offset: Offset(5, 0),
                                                          blurRadius: 20,
                                                          color: Colors.black12)
                                                    ]),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.repeat,
                                                      color: Colors.black,
                                                    ),
                                                    Text(
                                                      "Nochmal",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              splashColor: Appcolors.primary,
                                              onPressed: () {
                                                _hiveCredit.hackenSetzen(true);
                                                _hiveCredit
                                                    .putControllTime(timeleft);
                                                _hiveCredit
                                                    .addGenerallControllTime(
                                                        timeleft);
                                                _hiveCredit
                                                    .putAnalyseValueToHive(
                                                        widget.nameUebung,
                                                        timeleft);
                                                widget.onForwardPressed();
                                              },
                                              icon: Icon(
                                                Icons.done,
                                                color: Appcolors.primary,
                                              ),
                                              color: Appcolors.primary,
                                            )
                                          ],
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
                                                  const MyBottomNavigationBar(
                                                    startindex: 0,
                                                  )),
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
                              SizedBox(
                                  width: 130,
                                  height: 40,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Appcolors.primary, width: 3),
                                        borderRadius:
                                            BorderRadius.circular(24)),
                                    child: Center(
                                      child: MyIntField(
                                          controller: controller,
                                          text: "Geschaffte WH",
                                          obscureText: false,
                                          fontSize: 12),
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: widget.onBackwardPressed,
                                        icon: const Icon(Icons.arrow_back_ios,
                                            size: 40)),
                                    IconButton(
                                        onPressed: () {
                                          _hiveCredit.hackenSetzen(true);
                                          _hiveCredit.putAnalyseValueToHive(
                                              widget.nameUebung,
                                              covertWH(controller.text));
                                          _hiveCredit.putControllTime(
                                              covertWH(controller.text));
                                          _hiveCredit.addGenerallControllTime(
                                              covertWH(controller.text));
                                          widget.onForwardPressed();
                                        },
                                        icon: Icon(
                                          Icons.done,
                                          color: Appcolors.primary,
                                          size: 45,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          // Hier muss man auf Type error aufpassen
                                          widget.onForwardPressed();
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 40,
                                        )),
                                  ],
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                                                  Radius
                                                                      .circular(
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
                                                    const MyBottomNavigationBar(
                                                      startindex: 0,
                                                    )),
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

class VideoWidgetTest extends StatefulWidget {
  final bool looping;
  final String videoData;

  const VideoWidgetTest(
      {super.key, required this.looping, required this.videoData});

  @override
  State<VideoWidgetTest> createState() => _VideoWidgetTestState();
}

class _VideoWidgetTestState extends State<VideoWidgetTest> {
  late YoutubePlayerController _controller;

  void listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      // Das Video wurde beendet. Hier kannst du Aktionen ausführen.
      // Zum Beispiel das Video auf den Anfang setzen und pausieren:
      if (_controller.value.position != const Duration(seconds: 0)) {
        _controller.seekTo(const Duration(seconds: 0));
        widget.looping == true ? _controller.play() : _controller.pause();
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
    return showError == true
        ? SpinKitFadingFour(
            color: Appcolors.primary,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              YoutubePlayer(
                aspectRatio: 4 / 3,
                controller: _controller,
                showVideoProgressIndicator: false,
                onEnded: (metaData) {
                  _controller.pause();
                  widget.looping == false
                      ? setState(() {
                          playVisible = true;
                        })
                      : () {};
                },

                controlsTimeOut: Duration(
                    seconds:
                        4), // Zeit, bis die Bedienelemente ausgeblendet werden
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
