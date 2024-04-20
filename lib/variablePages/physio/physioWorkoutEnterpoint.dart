import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_projekt/heatmap/funktions.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:wakelock/wakelock.dart';
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
      for (int i = 0; i < 3; i++) {
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
              SizedBox(
                height: 30,
              ),
              Text(
                "Sind Sie sich sicher, dass Sie diese Übung überspringen möchten? Als Konsequenz wird diese Übung bei Ihrem Therapeuten als übersprungen angezeigt.",
                style: TextStyle(
                    fontSize: 16, color: Colors.black, fontFamily: "Laxout"),
                textAlign: TextAlign.center,
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
                            color: Colors.white, fontFamily: "Laxout"),
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
                      _hive.putIndexPhysioList(currentIndex);
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("After forward pressed:${_hive.getIndexPhysioList()}");
                            print("Current index: $currentIndex");
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
                            color: Colors.white, fontFamily: "Laxout"),
                      )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              )
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
              content: Container(
                color: Colors.white,
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
                              builder: (context) => const SeeSuccesPage()),
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
                                  color: Colors.white,
                                  fontFamily: "Laxout",
                                  fontSize: 20),
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
  AudioPlayer player = AudioPlayer();
  int currentIndex = 0;
  int progressIndex = 0;
  String currentVideoPath = "";

  Future<void> _play() async {
    await player.resume();
  }




  int tutorialCount = 0;
String text1 = "Nun können wir endlich mit Ihrem Workout loslegen!";//Title text
String text2 = "Sie sehen nun immer eine passende Videoanleitung, die die Übung vormacht. Außerdem haben Sie einen Timer/Anzahl der Wiederholungen, die Ihnen verrät wie oft bzw. wie lange Sie eine Übung machen sollen. Ist dieser Timer abgelaufen, oder haben Sie die Anzahl an auszuführenden Wiederhohlungen gemacht, springt die App automatisch zur nächsten Übung.";//Body text
String text3 = "Weiter"; //Button text
  void showWelcomeDialog(){
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
            title: Text(text1,textAlign: TextAlign.center, style: TextStyle(fontFamily: "Laxout", fontSize: 22, color: Colors.black),),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text2,textAlign: TextAlign.center, style: TextStyle(fontFamily: "Laxout", fontSize: 14,color: Colors.black),),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      tutorialCount ++;
                      if(tutorialCount == 1){
                        setState(() {
                          text1 = "Was wenn ich eine Übung unpassend finde ?";
                          text2 = "Kein Problem! Mit den Pfeiltasten, die nach links und rechts zeigen, können Sie zwischen den einzelnen Übungen hin und her springen. Möchten Sie allerdings eine Übung überspringen, wird das vermerkt.";
                          text3 = "Weiter";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 2){
                        setState(() {
                          text1 = "Tipp";
                          text2 = "Wenn Sie Ihr Handy während der Übung nicht in der Hand halten wollen, können Sie Ihr Handy auf laut stellen und die App vibriert sobald der Timer abgelaufen ist.";
                          text3 = "Weiter";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }

                      
                      if(tutorialCount == 3){
                        setState(() {
                          text1 = "Und eins noch:";
                          text2 = "Wenn Sie wissen möchten, ob es bei einer Übung etwas zu beachten gibt, können Sie auf die Glühbirne links unten tippen, um sich einen detailierten Ausführungstext anzeigen zu lassen. Jetzt lassen Sie uns aber mit den Übungen starten!";
                          text3 = "Starten";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 4){
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: 120,
                      decoration: BoxDecoration(color: Appcolors.primary, borderRadius: BorderRadius.circular(20),),
                      child: Center(child: Text(text3, style: TextStyle(color: Colors.white, fontSize: 16),),),
                    ),
                  )
                ],
              ),
            ],
          );
        }));
  }

bool showTutorial = false;
  @override
  void initState() {
    showTutorial = !_hive.getphysioEnterPointWasOpened();
    _hive.physioEnterPointWasOpened();
    showTutorial? WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog();
    }):(){};
    Wakelock.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(AssetSource('assets/audio/exercisefinished.mp3'));
    });
    isInternetConnected();
    if (isConnected == true) {}
    days = _heatmap.getDaysList();
    super.initState();
    currentIndex = _hive.getIndexPhysioList();
    progressIndex = currentIndex;
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
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
                    videoPath: list[currentIndex]
                        .videoPath, // Aktualisierter Video-Pfad
                    onBackwardPressed: () {
                      setState(() {
                        if (currentIndex > 0) {
                          
                          currentIndex--;
                          progressIndex--;
                          _hive.putIndexPhysioList(currentIndex);
                          currentVideoPath = list[currentIndex]
                              .videoPath; // Aktualisierung des Video-Pfads
                        }
                      });
                    },

                    onForwardPressed: () async {
                      print("C Time");
                       _play();
                      print(_hiveCredit.getControlltime());
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
                            _play();
                            vibratePhone();
                            progressIndex++;
                            _hive.putIndexPhysioList(currentIndex);
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("####################################################################################################");
                            print("After forward pressed:${_hive.getIndexPhysioList()}");
                            print("Current index: $currentIndex");
                            currentVideoPath = list[currentIndex]
                                .videoPath; // Aktualisierung des Video-Pfads
                          } else {
                            progressIndex++;
                            dialogShow();
                            _hive.putIndexPhysioList(0);
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
