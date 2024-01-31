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
import 'package:new_projekt/variablePages/tests/UebungForTest.dart';
import 'package:vibration/vibration.dart';

class TestsEnterPoint extends StatefulWidget {
  const TestsEnterPoint({
    Key? key,
  }) : super(key: key);

  @override
  State<TestsEnterPoint> createState() => _TestsEnterPointState();
}

class _TestsEnterPointState extends State<TestsEnterPoint> {
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  bool isConnected = false;

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

  void putConvertedListInHive() async {
    final toPut = await convertList();
    _hiveCredit.saveTestWorkout(toPut);
  }
  //abcdefghijklmnop

  Future<List<UebungList>> convertList() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercises();

    final toReturn =
        await _hiveCredit.convertStrenghtWorkoutsToUebungList(toConvert);
    return toReturn;
  }

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

  void showHackenSetzenError() {
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
                      "Sie haben ihr Ergebnis noch nicht gespeichert! Wenn Sie ihr Ergebnis speichern möchten, drücken Sie auf den Zurück-Button und dann auf den blauen Hacken. Sehen Sie keinen blauen Hacken, müssen Sie zuerst den Timer starten. Sie erhalten sonst keine Belohnung.",
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
                            width: 120,
                            height: 30,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(176, 224, 230, 1.0),
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Zurück",
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
                            Navigator.of(context).pop();
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
                                  _hiveCredit.clearControllTime();

                                  actuallcredits = _hiveCredit.getCredits();
                                  actuallcredits = actuallcredits + credits;
                                  _hiveCredit.addCredits(actuallcredits);
                                  _hiveCredit.putRefferenceValueToHive(
                                      requiredListForHive());
                                  sendIndex();
                                  _hiveCredit
                                      .deleteDatasets(requiredListForHive());
                                  days.add(createDateTimeObject(
                                      todaysDateFormatted()));
                                  _heatmap.saveToday(days);
                                  _heatmap.putDaysinMap(days);
                                  _hiveCredit.clearGenerallControllTime();
                                }
                              }
                            });
                          },
                          child: Container(
                            width: 120,
                            height: 30,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(176, 224, 230, 1.0),
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Skip",
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

  int getMinControllTime() {
    int unnoetig = 0;
    int toReturn = 0;

    unnoetig = (list.length * 10)
        .round(); // List.length ist ein float und muss daher gerundet werden.
    toReturn += unnoetig;
    return toReturn;
  } // Ermittelt wie lange der User midestens seine Übugne machen muss

  int currentIndex = 0;
  List list = [
  ];
  late String currentVideoPath;
  Key uniqueKey = UniqueKey();
  TextEditingController controller = TextEditingController();
  // Liefert die Liste aus Keys, um in hive alle Werte zu speichern oder die Zellen zu löschem
  List<String> requiredListForHive() {
    List<String> toReturn = [];
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        toReturn.add(list[i].name);
      }
    }
    return toReturn;
  }

  void sendIndex() async {
    int temporaryIndex = _hiveCredit.returnLeitungsIndex();
    await _laxoutBackend.postLeistungsIndex(temporaryIndex);
    await _laxoutBackend.finishWorkout(2);
  }

  @override
  void initState() {
    _hiveCredit.hackenSetzen(false);
    isInternetConnected();
    if (list.isNotEmpty) {
      isConnected
          ? putConvertedListInHive()
          : () {
            };
    }
    list = _hiveCredit.getTestWorkoutList();
    list.isNotEmpty ? currentVideoPath = list[0].videoPath : () {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? Scaffold(
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: UebungForTests(
                key: uniqueKey,
                timer: list[currentIndex].timer,
                looping: list[currentIndex].looping,
                ausfuehrung: list[currentIndex].execution,
                nameUebung: list[currentIndex].name,
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
                  if (_hiveCredit.getHacken() == false) {
                    showHackenSetzenError();
                  } else {
                    _hiveCredit.hackenSetzen(false);
                    if (_hiveCredit.getControlltime() + 1 >
                        list[currentIndex].dauer) {
                      await _laxoutBackend
                          .finishExercise(list[currentIndex].id);
                    }
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
                          _hiveCredit.clearControllTime();

                          actuallcredits = _hiveCredit.getCredits();
                          actuallcredits = actuallcredits + credits;
                          _hiveCredit.addCredits(actuallcredits);
                          _hiveCredit
                              .putRefferenceValueToHive(requiredListForHive());
                          sendIndex();

                          _hiveCredit.deleteDatasets(requiredListForHive());
                          days.add(createDateTimeObject(todaysDateFormatted()));
                          _heatmap.saveToday(days);
                          _heatmap.putDaysinMap(days);
                          _hiveCredit.clearGenerallControllTime();
                        }
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
                        "In Ihrer individuellen Behandlungsroutine sind keine Kräftigungsübungen vorhanden....\nBitten Sie ihren Therapeuten darum welche hinzuzufügen, um diese Funktion nutzen zu können.",
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
/*import 'package:flutter/material.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/Uebung.dart';
import 'package:new_projekt/variablePages/tests/UebungForTest.dart';

class TestsEnterPoint extends StatefulWidget {
  final List list;

  const TestsEnterPoint({
    super.key,
    required this.list,
  });

  @override
  State<TestsEnterPoint> createState() => _TestsEnterPointState();
}

class _TestsEnterPointState extends State<TestsEnterPoint> {
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
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    list = widget.list;
    days = _heatmap.getDaysList();
    currentVideoPath = list[currentIndex].videoPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: UebungForTests(
          timer: list[currentIndex].timer,
          looping: list[currentIndex].looping,
          ausfuehrung: list[currentIndex].ausfuehrung,
          nameUebung: list[currentIndex].nameUebung,
          controller: controller,
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
          onForwardPressed: () {
            _hiveCredit.clearControllTime();
            setState(() {
              if (currentIndex < list.length - 1) {
                currentIndex++;
                currentVideoPath = list[currentIndex]
                    .videoPath; // Aktualisierung des Video-Pfads
              } else {
                dialogShow();
                if (_hiveCredit.getControlltime() >= 1) {
                  print("Chaka");
                  _hiveCredit.clearControllTime();
                  actuallcredits = _hiveCredit.getCredits();
                  actuallcredits = actuallcredits + credits;
                  _hiveCredit.addCredits(actuallcredits);
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
*/
