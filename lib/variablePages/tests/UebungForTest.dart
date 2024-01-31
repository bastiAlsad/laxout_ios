// ignore: file_names
// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_projekt/models/intfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/navigation/Side_Nav_Bar.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/Uebung.dart';

// ignore: must_be_immutable
class UebungForTests extends StatefulWidget {
  final String ausfuehrung;
  final String nameUebung;
  final VoidCallback onForwardPressed;
  final VoidCallback onBackwardPressed;
  String videoPath;
  final bool looping;
  final bool timer;

  UebungForTests({
    Key? key,
    required this.ausfuehrung,
    required this.nameUebung,
    required this.onForwardPressed,
    required this.onBackwardPressed,
    this.videoPath = "",
    required this.looping,
    required this.timer,
  }) : super(key: key);

  

  @override
  State<UebungForTests> createState() => _UebungForTestsState();
}

class _UebungForTestsState extends State<UebungForTests>
    with SingleTickerProviderStateMixin {
  final HiveDatabase _hiveCredit = HiveDatabase();
  int actualControlltime = 0;
  TextEditingController controller = TextEditingController();
  late Key _videoKey; // Neuer Key für das LoopingVideo
  int covertWH(String wh) {
    int toReturn = 0;
    toReturn = int.parse(wh);
    return toReturn;
  }

  @override
  void initState() {
    if (widget.timer == true) {}
    _videoKey = UniqueKey();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UebungForTests oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != oldWidget.videoPath) {
      _videoKey =
          UniqueKey(); // Aktualisierung des Keys, wenn sich der Video-Pfad ändert
    }
  }

  int time = 0;
  int toPercent = 1;
  double timerWidth = 200;
  bool startvisible = true;
  bool stopvisible = false;
  bool stoppressed = false;
  bool againpressed = false;
  bool againvisible = false;
  late AnimationController _animationController;

  String getTime() {
    return time.toString();
  }

  void timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (stoppressed == false) {
          time++;
          toPercent++;
        } else {
          timer.cancel();
          time > 15 ? _hiveCredit.addControllTime(30) : () {};
          if (time == 0 || againpressed == true) {
            againpressed = false;
            stopvisible = false;
            startvisible = true;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                progressColor:
                                    const Color.fromRGBO(176, 224, 230, 1.0),
                                backgroundColor: Colors.white,
                                center: Text(
                                  time.toString(),
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
                                        stopvisible = false;
                                        stoppressed = true;
                                        againvisible = true;
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
                                            timer();
                                            stopvisible = false;
                                            startvisible = true;
                                            stoppressed = true;
                                            againvisible = false;
                                            time = 0;
                                            toPercent = 1;
                                            _hiveCredit.addCredits(time);
                                          },
                                          child: Container(
                                            width: 110,
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
                                            _hiveCredit.addControllTime(time);
                                            _hiveCredit
                                                .addGenerallControllTime(time);
                                            _hiveCredit.putAnalyseValueToHive(
                                                widget.nameUebung, time);
                                            //‚widget.onForwardPressed();
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
                                              const MyBottomNavigationBar()),
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
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    onPressed: widget.onBackwardPressed,
                                    icon: const Icon(Icons.arrow_back_ios,
                                        size: 40)),
                                const SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Wie viele Wiederholungen haben sie geschafft ?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Laxout",
                                          fontSize: 15),
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
                          const SizedBox(
                            height: 20,
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
                                    borderRadius: BorderRadius.circular(24)),
                                child: Center(
                                  child: MyIntField(
                                      controller: controller,
                                      text: "Bitte eintragen",
                                      obscureText: false,
                                      fontSize: 12),
                                ),
                              )),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40.0),
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
                                      _hiveCredit.hackenSetzen(true);
                                      _hiveCredit.putAnalyseValueToHive(
                                          widget.nameUebung,
                                          covertWH(controller.text));
                                      _hiveCredit.addControllTime(
                                          covertWH(controller.text));
                                      _hiveCredit.addGenerallControllTime(
                                          covertWH(controller.text));
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
                                                const MyBottomNavigationBar()),
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
