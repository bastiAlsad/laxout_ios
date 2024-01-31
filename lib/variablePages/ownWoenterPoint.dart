import 'package:flutter/material.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/Uebung.dart';
import 'package:vibration/vibration.dart';

class OwnWorkoutEnterPoint extends StatefulWidget {
  final int index;
  const OwnWorkoutEnterPoint({Key? key, required this.index}) : super(key: key);

  @override
  State<OwnWorkoutEnterPoint> createState() => _OwnWorkoutEnterPointState();
}

class _OwnWorkoutEnterPointState extends State<OwnWorkoutEnterPoint> {
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
   List<DateTime> days = [];
  final HiveHeatmap _heatmap = HiveHeatmap();
  final HiveDatabase _hiveCredit = HiveDatabase();
  // wie viel hinzugefügt wird
  int credits = 50;
  // Addierem von den Credits
  int actuallcredits = 0;
  void vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      Vibration.vibrate();
    } else {
      // Das Gerät unterstützt keine Vibration
    }
  }

  void dialogShow() {
    vibratePhone();
    showDialog<AlertDialog>(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              content: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                width: MediaQuery.of(context).size.width - 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LoopingVideo(
                        videoData: "assets/videos/credits.mp4", looping: true),
                    const Text(
                      "Toll gemacht, das war die letzte Übung!",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyBottomNavigationBar()),
                          (route) => false),
                      child: Container(
                        width: 100,
                        height: 30,
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

  final HiveDatabase _hive = HiveDatabase();
  int currentIndex = 0;
  List list = [];
  late String currentVideoPath;

  @override
  void initState() {
    if (widget.index == 0) {
      list = _hive.loadOwnWorkout();
    } else {
      if (widget.index == 1) {
        list = _hive.loadOwnWorkout2();
      } else {
        if (widget.index == 2) {
          list = _hive.loadOwnWorkout3();
        } else {
          if (widget.index == 3) {
            list = _hive.loadOwnWorkout4();
          }
        }
      }
    }

    currentVideoPath = list[currentIndex].videoPath;
    _hive.selectedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Uebung(
          timer: true,
          looping: true,
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
          onForwardPressed: () async{
            if (_hiveCredit.getControlltime() + 1 >
                list[currentIndex].dauer) {
              await _laxoutBackend.finishWorkout(
                  list[currentIndex].id);
              _hiveCredit.clearControllTime();
            }
            setState(() {
              if (currentIndex < list.length - 1) {
                currentIndex++;
                currentVideoPath = list[currentIndex]
                    .videoPath; // Aktualisierung des Video-Pfads
              } else {
                dialogShow();
                if (_hiveCredit.getControlltime() > 150) {
                  _hiveCredit.clearControllTime();
                  actuallcredits = _hiveCredit.getCredits();
                  actuallcredits = actuallcredits + credits;
                  _hiveCredit.addCredits(actuallcredits);
                  
                }
                days.add(createDateTimeObject(todaysDateFormatted()));
                _heatmap.saveToday(days);
                _heatmap.putDaysinMap(days);
              }
            });
          },
        ),
      ),
    );
  }
}
