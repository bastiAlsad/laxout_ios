import 'package:flutter/material.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/Uebung.dart';

class UebungHomeEnterPoint extends StatefulWidget {
  final int index;

  final List workouts;

  final int controlltime;

  final int workoutId;

  const UebungHomeEnterPoint(
      {super.key,
      required this.index,
      required this.workouts,
      required this.controlltime,
      required this.workoutId});

  @override
  State<UebungHomeEnterPoint> createState() => _UebungHomeEnterPointState();
}

class _UebungHomeEnterPointState extends State<UebungHomeEnterPoint> {
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  List<DateTime> days = [];
  final HiveHeatmap _heatmap = HiveHeatmap();
  final HiveDatabase _hiveCredit = HiveDatabase();
  // wie viel hinzugefügt wird
  int credits = 50;
  // Addierem von den Credits
  int actuallcredits = 0;
  void dialogShow() {
    showDialog<AlertDialog>(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              content: SizedBox(
                width: 290,
                height: 450,
                child: ListView(
                  children: [
                    const LoopingVideo(
                        videoData: "assets/videos/credits.mp4", looping: true),
                    const Text(
                      "Toll gemacht, das war die letzte Übung!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Laxout'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const MyBottomNavigationBar()),
                          (route) => false),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(176, 224, 230, 1.0),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Laxout"),
                            ),
                            Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                          ],
                        )),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  int currentIndex = 0;
  List list = [];
  late String currentVideoPath;

  @override
  void initState() {
    super.initState();
    list = widget.workouts;
    days = _heatmap.getDaysList();

    currentVideoPath = list[currentIndex].videoPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Uebung(
          timer: true,
          looping: list[currentIndex].looping,
          ausfuehrung: list[currentIndex].execution,
          nameUebung: list[currentIndex].name,
          dauer: list[currentIndex].dauer,
          videoPath: currentVideoPath, // Aktualisierter Video-Pfad
          onBackwardPressed: () {
            setState(() {
              if (currentIndex > 0) {
                currentIndex--;
                currentVideoPath = list[currentIndex]
                    .videoPath; // Aktualisierung des Video-Pfads
              }
            });
          },
          onForwardPressed: () async {
            if (_hiveCredit.getControlltime() + 1 > list[currentIndex].dauer) {
              _laxoutBackend.finishExercise(list[currentIndex].id);
            }
            setState(() {
              if (currentIndex < list.length - 1) {
                currentIndex++;
                currentVideoPath = list[currentIndex]
                    .videoPath; // Aktualisierung des Video-Pfads
              } else {
                dialogShow();
                if (_hiveCredit.getControlltime() >= widget.controlltime) {
                  _hiveCredit.clearControllTime();
                  actuallcredits = _hiveCredit.getCredits();
                  actuallcredits = actuallcredits + credits;
                  _hiveCredit.addCredits(actuallcredits);
                  _laxoutBackend.finishWorkout(widget.workoutId);
                  days.add(createDateTimeObject(todaysDateFormatted()));
                  _heatmap.saveToday(days);
                  _heatmap.putDaysinMap(days);
                }
              }
            });
          },
        ),
      ),
    );
  }
}
