// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_projekt/navPages/Homepage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:video_player/video_player.dart';

import 'package:new_projekt/navigation/Side_Nav_Bar.dart';

class UebungUebungsUebersicht extends StatefulWidget {
  final String ausfuehrung;
  final String nameUebung;
  final VoidCallback onForwardPressed;
  final VoidCallback onBackwardPressed;
  final int dauer;
  final String videoPath;
  final String imagePath;

  const UebungUebungsUebersicht({
    Key? key,
    required this.ausfuehrung,
    required this.nameUebung,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    required this.dauer,
    required this.videoPath,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<UebungUebungsUebersicht> createState() =>
      _UebungUebungsUebersichtState();
}

class _UebungUebungsUebersichtState extends State<UebungUebungsUebersicht>
    with SingleTickerProviderStateMixin {
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
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    timeleft = widget.dauer;
    toPercent = widget.dauer;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
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
                child: LoopingVideo(videoData: widget.videoPath),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 3,
            left: 10,
            child: IconButton(
              onPressed: () {
                showDialog<AlertDialog>(
                    barrierColor: Colors.white.withOpacity(0),
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          content: Text(
                            "Ausführung:\n${widget.ausfuehrung}",
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ));
                    });
              },
              icon: const Icon(
                Icons.lightbulb,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 3,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                  (route) => false,
                );
              },
              icon: const Icon(
                Icons.home,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - timerWidth / 2,
            child: Center(
              child: SizedBox(
                height: 270,
                width: timerWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 60,
                      percent: (timeleft / toPercent).toDouble(),
                      animation: true,
                      animationDuration: 1000,
                      animateFromLastPercent: true,
                      lineWidth: 10,
                      progressColor: const Color.fromRGBO(176, 224, 230, 1.0),
                      backgroundColor: Colors.white,
                      center: Text(
                        timeleft.toString(),
                        style:
                            const TextStyle(fontSize: 30, color: Colors.black),
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
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(5, 0),
                                        blurRadius: 20,
                                        color: Colors.black12)
                                  ]),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_sharp,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Start",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
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
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(5, 0),
                                        blurRadius: 20,
                                        color: Colors.black12)
                                  ]),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.stop,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    "Stop",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 6 + 30,
            left: 30,
            child: IconButton(
                onPressed: widget.onBackwardPressed,
                icon: const Icon(Icons.arrow_back_ios, size: 40)),
          ),
          Positioned(
            right: 30,
            bottom: MediaQuery.of(context).size.height / 6 + 30,
            child: IconButton(
                onPressed: widget.onForwardPressed,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 40,
                )),
          )
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}

class LoopingVideo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final videoData;
  const LoopingVideo({Key? key, required this.videoData}) : super(key: key);

  static _LoopingVideoState? of(BuildContext context) =>
      context.findAncestorStateOfType<_LoopingVideoState>();

  @override
  // ignore: library_private_types_in_public_api
  _LoopingVideoState createState() => _LoopingVideoState();
}

class _LoopingVideoState extends State<LoopingVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoData)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.play())
      ..initialize().then((_) => _controller.play()).catchError((error) {
      });
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
      return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
