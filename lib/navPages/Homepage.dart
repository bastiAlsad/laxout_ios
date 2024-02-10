// ignore_for_file: must_be_immutable
//_hiveCredit.getCredits()
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/models/ownWorkoutList.dart';
import 'package:new_projekt/navPages/errorPage.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/Uebung.dart';
import 'package:new_projekt/variablePages/physio/physioWorkoutEnterpoint.dart';
import 'package:new_projekt/variablePages/tests/TestEnterpoint.dart';
import 'package:new_projekt/variablePages/tests/umfrage.dart';
import '../navigation/Side_Nav_Bar.dart';
import 'package:vibration/vibration.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  Future<String?> _getLaxCoinsStream() async {
    String? laxCoins = await _laxoutBackend.getLaxoutCoinsAmount();
    return laxCoins;
  }

  int dayCount = 0;
  final HiveDatabase _hive = HiveDatabase();
  final HiveHeatmap _heatmap = HiveHeatmap();
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  final _myBox = Hive.box("Workout_Map");
  bool added = false;
  bool provider = false;
  int ownWorkoutIndex = 0;
  int test = 0;
  bool isConnected = true;
  int week = 1;

  String nameWorkout = "";
  List<DateTime> days = [];
  List<DateTime> today = [];
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

  void putConvertedListInHive() async {
    final toPut = await convertList();
    _hive.savePhysioWorkout(toPut);
  }

  Future<List<UebungList>> convertList() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercises();

    final toReturn = await _hive.convertWorkoutsToUebungList(toConvert);
    return toReturn;
  }

  //Test void
  void putConvertedTestListInHive() async {
    final toPut = await convertTestList();
    _hive.saveTestWorkout(toPut);
  }

  Future<List<UebungList>> convertTestList() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercisesTest();

    final toReturn = await _hive.convertStrenghtWorkoutsToUebungList(toConvert);
    return toReturn;
  }

  String instruction = "";
  bool logoValid = true;

  Future<String> getInstruction() async {
    String? testinsruction = "";
    testinsruction = await _laxoutBackend.returnInstruction();
    if (testinsruction != null) {
      return testinsruction;
    } else {
      return "Keine Anweisung vorhanden";
    }
  }

  Future<int?> manageWeek() async {
    return await _laxoutBackend.returnProgressWeek();
  }

  @override
  void initState() {
    isInternetConnected();
    isConnected ? putConvertedListInHive() : () {};
    isConnected ? putConvertedTestListInHive() : () {};
     list = _hive.getTestWorkoutList(); //Stehen Lassen, sonst zeigt Test logik error an
    _initializeApp();

    days = _heatmap.getDaysList();
    today = _heatmap.getToday();
    if (_myBox.isEmpty) {
      _hive.createInitialData();
    } else {
      _hive.loadData();
    }

    super.initState();
  }

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

  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                              builder: (context) => const MyBottomNavigationBar(
                                    startindex: 0,
                                  )),
                          (route) => false),
                    ),
                  ],
                ),
              ));
        });
  }

  List<String> requiredStuff() {
    List listUebungen = _hive.getPhysioWorkoutList();
    List<String> requiredStuff = [];
    bool kommtVor = false;
    for (int j = 0; j < listUebungen.length; j++) {
      for (int i = 0; i < requiredStuff.length; i++) {
        if (listUebungen[j].required == requiredStuff[i]) {
          kommtVor = true;
        }
      }
      if (kommtVor == false && listUebungen[j].required != "") {
        requiredStuff.add(listUebungen[j].required);
      }
    }
    return requiredStuff;
  }

  //Für Test
  List<String> requiredTestStuff() {
    List listUebungen = _hive.getTestWorkoutList();
    List<String> requiredStuff = [];
    bool kommtVor = false;
    for (int j = 0; j < listUebungen.length; j++) {
      for (int i = 0; i < requiredStuff.length; i++) {
        if (listUebungen[j].required == requiredStuff[i]) {
          kommtVor = true;
        }
      }
      if (kommtVor == false && listUebungen[j].required != "") {
        requiredStuff.add(listUebungen[j].required);
      }
    }
    return requiredStuff;
  }

  void showNeededStuff(List list, Widget aim) {
    List toDisplay = list;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Folgendes wird für dieses Workout benötigt:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Laxout", fontSize: 24),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: ListView.builder(
                            itemCount: toDisplay.length,
                            itemBuilder: ((context, index) {
                              return Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "-" + toDisplay[index],
                                style: const TextStyle(
                                    fontFamily: "Laxout", fontSize: 18),
                              );
                            })),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => aim),
                            (route) => false),
                        child: Container(
                          height: 60,
                          width: 130,
                          decoration: BoxDecoration(
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(14)),
                          child: const Center(
                            child: Text(
                              "Starten",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Laxout",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]);
        });
  }

  bool neverOpened = false;
// Hive struktur anpassen
  void _initializeApp() async {
    _laxoutBackend.authenticateUser(_hive.getUserUid());
    if (_hive.neverOpened() == true) {
      neverOpened = true;
      try {} catch (e) {
        // Behandeln Sie den Fehler hier, beispielsweise durch Anzeigen einer Fehlermeldung für den Benutzer.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 60,
        leading: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            SizedBox(
              height: 45,
              width: 45,
              child: IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Image.asset('assets/images/drawer.png')),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          SizedBox(
              height: 60,
              width: 60,
              child: Image.asset("assets/images/Logoohneschrift.png")),

     
          const SizedBox(
            width: 8,
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              width: 900,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Laxout",
                    //_hiveCredit.getPraxisName(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: "Laxout",
                        height: 0),
                  ),
                  InkWell(
                    onTap: () {
                      showNeededStuff(
                              requiredTestStuff(),  const UmfragePage(toDelegate: TestsEnterPoint(),))
                          ;
                    },
                    child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Appcolors.primary,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "Test",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Laxout"),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: InkWell(
              onTap: () {
                  showNeededStuff(
                              requiredTestStuff(),  const UmfragePage(toDelegate: PhysioEnterPoint(),))
                         ;
              },
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -5),
                          blurRadius: 15),
                      BoxShadow(
                          color: Colors.grey.shade300,
                          offset: const Offset(-5, -5),
                          blurRadius: 15),
                    ],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 30, left: 30, bottom: 40, top: 40),
                      child: Image.asset("assets/images/physioworkout.png"),
                    ),
                    const Positioned(
                        child: Text(
                      "Physio Workout",
                      style: TextStyle(fontFamily: "Laxout", fontSize: 35),
                    )),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          height: 50,
                          width: 145,
                          decoration: BoxDecoration(
                              color: Appcolors.primary,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          child: const Center(
                              child: Text(
                            "Starten",
                            style: TextStyle(
                                fontFamily: "Laxout",
                                color: Colors.white,
                                fontSize: 18),
                          )),
                        )),
                    Positioned(
                      bottom: 0,
                      right: 20,
                      child: SizedBox(
                        height: 70,
                        width: 150,
                        child: Center(
                          child: FutureBuilder(future: getInstruction(), builder: (context,snapshot)=>snapshot.connectionState== ConnectionState.waiting?SpinKitFadingFour(color: Appcolors.primary,):Text(snapshot.data??"", style: TextStyle(fontFamily: "Laxout", fontSize: 12,),)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              height: 125,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, -5),
                        blurRadius: 15),
                    BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(-5, -5),
                        blurRadius: 15),
                  ],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25))),
              child: FutureBuilder(
                  future: manageWeek(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitFadingFour(
                        color: Appcolors.primary,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                       num currentProgress = snapshot.data ?? 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ihr Fortschritt:",
                              style: TextStyle(
                                  fontFamily: "Laxout",
                                  fontSize: 20,
                                  color: Colors.black87),
                            ),
                            Text(
                              "Woche $currentProgress von 8",
                              style: TextStyle(
                                  color: Colors.grey.shade300, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade100,
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(20),
                              value: currentProgress / 8,
                              semanticsLabel: 'Linear progress indicator',
                              minHeight: 20,
                            ),
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Internal Server Error"),
                    );
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Ihre verdienten LaxCoins:",
                  style: TextStyle(color: Colors.black, fontFamily: "Laxout"),
                ),
                FutureBuilder<String?>(
                  future: _getLaxCoinsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitFadingFour(color: Appcolors.primary,);
                    } else if (snapshot.hasError) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset("assets/images/laxCoin.png"),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          const Text(
                            '0',
                            style:
                                TextStyle(fontFamily: "Laxout", fontSize: 20),
                          ),
                        ],
                      );
                    } else {
                      String laxCoins = snapshot.data ?? "0";
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset("assets/images/laxCoin.png"),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Text(
                            laxCoins,
                            style: const TextStyle(
                                fontFamily: "Laxout", fontSize: 20),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}
