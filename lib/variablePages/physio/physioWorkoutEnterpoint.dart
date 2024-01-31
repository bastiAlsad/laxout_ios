import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/models/ownWorkoutList.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

import 'package:new_projekt/variablePages/Uebung.dart';
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
  void finishWorkout() async{
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

  void putConvertedListInHive() async {
    final toPut = await convertList();
    _hive.savePhysioWorkout(toPut);
  }

  Future<List<UebungList>> convertList() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercises();
    final toReturn = await _hive.convertWorkoutsToUebungList(toConvert);
    return toReturn;
  }

  List<DateTime> days = [];

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
              content: SizedBox(
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width - 75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset("assets/images/error.png"),
                    const Text(
                      "Sind Sie sich sicher, dass Sie diese Übung überspringen möchten? Als Konsequenz wird diese Übung bei Ihrem Therapeuten als für Sie ungeeignet angezeigt.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Abbrechen",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Laxout"),
                                ),
                                Icon(
                                  Icons.repeat,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _laxoutBackend.skipExercise(id);
                            setState(() {
                              currentIndex++;
                              currentVideoPath = list[currentIndex]
                                  .videoPath; // Aktualisierung des Video-Pfads
                              uniqueKey = UniqueKey();
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
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Überspr.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Laxout"),
                                ),
                                Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                ),
                              ],
                            )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
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
                                  const MyBottomNavigationBar()),
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

  late String currentVideoPath;
  Key uniqueKey = UniqueKey();

  @override
  void initState() {
    isInternetConnected();
    isConnected ? putConvertedListInHive() : () {};
    list = _hive.getPhysioWorkoutList();
    list.isNotEmpty ? currentVideoPath = list[0].videoPath : currentVideoPath ="";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? Scaffold(
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Uebung(
                key: uniqueKey,
                timer: list[currentIndex].timer,
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
                      uniqueKey = UniqueKey();
                    }
                  });
                },

                onForwardPressed: () async {
                  if (_hiveCredit.getControlltime() + 1 >
                      list[currentIndex].dauer) {
                    await _laxoutBackend.finishExercise(list[currentIndex].id);
                  }
                  if (_hiveCredit.getControlltime() + 1 <
                          list[currentIndex].dauer &&
                      currentIndex < list.length - 1) {
                    showHackenSetzenError(list[currentIndex].id);
                  } else {
                    setState(() {
                      if (currentIndex < list.length - 1) {
                        currentIndex++;
                        currentVideoPath = list[currentIndex]
                            .videoPath; // Aktualisierung des Video-Pfads
                        uniqueKey = UniqueKey();
                      } else {
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
                        days.add(createDateTimeObject(todaysDateFormatted()));
                        _heatmap.saveToday(days);
                        _heatmap.putDaysinMap(days);
                      }
                    });
                  }
                },
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("assets/images/noData.png"),
                      const Text(
                        "Hmm hier ist kein Workout vorhanden.Checke deine Internetverbingung oder frage deinen Physio ob er das Workout schon erstellt hat.",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: "Laxout"),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MyBottomNavigationBar()),
                                (route) => false);
                          },
                          child: Container(
                            height: 40,
                            width: 127,
                            decoration: BoxDecoration(
                                color: Appcolors.primary,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                                child: Text(
                              "Zurück",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            )),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
