import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

import 'package:new_projekt/variablePages/Uebung.dart';
import 'package:new_projekt/variablePages/tests/Erfolgskontrolle.dart';
import 'package:vibration/vibration.dart';

class PhysioEnterPoint extends StatefulWidget {
  const PhysioEnterPoint({
    Key? key,
  }) : super(key: key);

  @override
  State<PhysioEnterPoint> createState() => _PhysioEnterPointState();
}

class _PhysioEnterPointState extends State<PhysioEnterPoint> {
  final HiveHeatmap _heatmap = HiveHeatmap();
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  final HiveDatabase _hiveCredit = HiveDatabase();
  bool isConnected = false;
  List list = [];

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
        return true;
      }
      // ignore: empty_catches
    } catch (e) {}
    isConnected = false;
    return false;
  }

  void finishWorkout() async {
    await _laxoutBackend.finishWorkout(1);
  }

  int getMinControllTime() {
    int unnoetig = 0;
    int toReturn = 0;

    unnoetig = (list.length * 10)
        .round(); // List.length ist ein float und muss daher gerundet werden.
    toReturn += unnoetig;
    return toReturn;
  } // Ermittelt wie lange der User midestens seine Übugne machen muss

  Future<void> putConvertedListInHive() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercises();
    final toPut = await _hive.convertWorkoutsToUebungList(toConvert);
    _hive.savePhysioWorkout(toPut);
    list = toPut;
    print("List in putConvertedList $list");
    // print("Video Path in putConvertedList  $currentVideoPath");
  }

  List<DateTime> days = [];

  // wie viel hinzugefügt wird
  int credits = 50;
  // Addierem von den Credits
  int actuallcredits = 0;
  void vibratePhone() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      for(int i =0; i<3; i++){
        Vibration.vibrate();
      }
    } else {
      // Das Gerät unterstützt keine Vibration
    }
  }

  void showHackenSetzenError(int id) {
    vibratePhone();
    showDialog<AlertDialog>(
        barrierColor: Colors.white.withOpacity(0),
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              
              actions: [
                SizedBox(height: 30,),
                Text(
                    "Sind Sie sich sicher, dass Sie diese Übung überspringen möchten? Als Konsequenz wird diese Übung bei Ihrem Therapeuten als übersprungen angezeigt.",
                    style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: "Laxout"),textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 130,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(176, 224, 230, 1.0),
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                              child: Text(
                                "Abbrechen",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Laxout"),
                              )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _laxoutBackend.skipExercise(id);
                          setState(() {
                            currentIndex++;
                            progressIndex++;
                            currentVideoPath = list[currentIndex]
                                .videoPath; // Aktualisierung des Video-Pfads
                          });
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 130,
                          height: 30,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(176, 224, 230, 1.0),
                              borderRadius: BorderRadius.circular(25)),
                          child: const Center(
                              child: Text(
                                "Überspr.",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Laxout"),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,)
              ],
              );
        });
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
                height: MediaQuery.of(context).size.height - 300,
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
                              builder: (context) =>
                                   const SeeSuccesPage()),
                          (route) => false),
                      child: Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(176, 224, 230, 1.0),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Weiter",
                              style: TextStyle(
                                  color: Colors.white, fontFamily: "Laxout", fontSize: 20),
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
  int progressIndex = 0;
  String currentVideoPath = "";

  @override
  void initState() {
    isInternetConnected();
    if(isConnected == true){}
    days = _heatmap.getDaysList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: putConvertedListInHive(),
        builder: ((context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? Scaffold(
                body: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Uebung(
                    timer: list[currentIndex].timer,
                    looping: list[currentIndex].looping,
                    ausfuehrung: list[currentIndex].execution,
                    nameUebung: list[currentIndex].name,
                    dauer: list[currentIndex].dauer,
                    videoPath: list[currentIndex].videoPath, // Aktualisierter Video-Pfad
                    onBackwardPressed: () {
                      setState(() {
                        if (currentIndex > 0) {
                          currentIndex--;
                          progressIndex--;
                          currentVideoPath = list[currentIndex]
                              .videoPath; // Aktualisierung des Video-Pfads
                        }
                      });
                    },

                    onForwardPressed: () async {
                      if (_hiveCredit.getControlltime() + 1 >
                          list[currentIndex].dauer) {
                        await _laxoutBackend
                            .finishExercise(list[currentIndex].id);
                      }
                      if (_hiveCredit.getControlltime() + 1 <
                              list[currentIndex].dauer &&
                          currentIndex < list.length - 1) {
                        showHackenSetzenError(list[currentIndex].id);
                      } else {
                        setState(() {
                          if (currentIndex < list.length - 1) {
                            currentIndex++;
                            vibratePhone();
                            progressIndex++;
                            currentVideoPath = list[currentIndex]
                                .videoPath; // Aktualisierung des Video-Pfads
                          } else {
                            progressIndex++;
                            dialogShow();
                            if (_hiveCredit.getGenerallControlltime() >
                                getMinControllTime()) {
                              finishWorkout();
                              _hiveCredit.clearControllTime();
                              _hiveCredit.clearGenerallControllTime();
                              actuallcredits = _hiveCredit.getCredits();
                              actuallcredits = actuallcredits + credits;
                              _hiveCredit.addCredits(actuallcredits);
                            }
                            days.add(
                                createDateTimeObject(todaysDateFormatted()));
                            _heatmap.saveToday(days);
                            _heatmap.putDaysinMap(days);
                          }
                        });
                      }
                    },
                    exerciseListLength: list.length,
                    currentIndex: progressIndex,
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: SpinKitFadingFour(
                  color: Appcolors.primary,
                ),
              )));
  }
}
