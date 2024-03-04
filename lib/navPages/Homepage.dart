// ignore_for_file: must_be_immutable
//_hiveCredit.getCredits()
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hive/hive.dart';
import 'package:laxout/heatmap/hive.dart';
import 'package:laxout/models/constans.dart';
import 'package:laxout/models/ownWorkoutList.dart';
import 'package:laxout/navigation/Bottom_Navigation_Bar.dart';
import 'package:laxout/navigation/Side_Nav_Bar.dart';
import 'package:laxout/services/basti_backend.dart';
import 'package:laxout/services/hive_communication.dart';
import 'package:laxout/variablePages/DesignerItem1.dart';
import 'package:laxout/variablePages/physio/physioWorkoutEnterpoint.dart';
import 'package:laxout/variablePages/tests/TestEnterpoint.dart';
import 'package:laxout/variablePages/tests/umfrage.dart';
import 'package:laxout/variablePages/uebungHomeenterpoint.dart';

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
    list = _hive
        .getTestWorkoutList(); //Stehen Lassen, sonst zeigt Test logik error an
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

  void openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List> workouList() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercises();
    return await _hive.convertWorkoutsToUebungList(toConvert);
  }

  Future<List> workouListTest() async {
    final toConvert = await _laxoutBackend.returnLaxoutExercisesTest();
    return await _hive.convertStrenghtWorkoutsToUebungList(toConvert);
  }

  Future<List<String>> requiredStuff() async {
    List listUebungen = [];
    final toConvert = await _laxoutBackend.returnLaxoutExercises();
    listUebungen = await _hive.convertWorkoutsToUebungList(toConvert);
    List<String> requiredStuff = [];
    final workoutList = await workouList();

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
    if (workoutList.isNotEmpty && requiredStuff.isEmpty) {
      requiredStuff.add("Nichts außer Sie selbst");
    }
    return requiredStuff;
  }

  //Für Test
  Future<List<String>> requiredTestStuff() async {
    List listUebungen = [];
    final toConvert = await _laxoutBackend.returnLaxoutExercisesTest();
    listUebungen = await _hive.convertStrenghtWorkoutsToUebungList(toConvert);
    List<String> requiredStuff = [];
    final workoutList = await workouListTest();

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
    if (workoutList.isNotEmpty && requiredStuff.isEmpty) {
      requiredStuff.add("Nichts außer Sie selbst");
    }
    return requiredStuff;
  }

  void showNeededStuff(bool test, Widget aim) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 420,
                    width: MediaQuery.of(context).size.width - 50,
                    child: FutureBuilder(
                      future: test ? requiredTestStuff() : requiredStuff(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: SpinKitFadingFour(color: Appcolors.primary),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          List toDisplay = snapshot.data ?? [];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              toDisplay.isNotEmpty
                                  ? Text(
                                      "Folgendes wird für dieses Workout benötigt:",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Laxout", fontSize: 24),
                                    )
                                  : Text(
                                      "In diesem Workout sind keine Übungen.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Laxout", fontSize: 24),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                    itemCount: toDisplay.length,
                                    itemBuilder: ((context, index) {
                                      return Center(
                                        child: Text(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "-" + toDisplay[index],
                                          style: const TextStyle(
                                              fontFamily: "Laxout",
                                              fontSize: 18),
                                        ),
                                      );
                                    })),
                              ),
                              toDisplay.isNotEmpty
                                  ? InkWell(
                                      onTap: () => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => aim),
                                          (route) => false),
                                      child: Container(
                                        height: 60,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            color: Appcolors.primary,
                                            borderRadius:
                                                BorderRadius.circular(14)),
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
                                    )
                                  : InkWell(
                                      onTap: () => Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyBottomNavigationBar(
                                                      startindex: 0)),
                                          (route) => false),
                                      child: Container(
                                        height: 60,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            color: Appcolors.primary,
                                            borderRadius:
                                                BorderRadius.circular(14)),
                                        child: const Center(
                                          child: Text(
                                            "Zurück",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: "Laxout",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          );
                        } else {
                          return Text(
                              "Für dieses Workout wird nichts benötigt");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }));
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
                          true,
                          const UmfragePage(
                            toDelegate: TestsEnterPoint(),
                          ));
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
                    false,
                    const UmfragePage(
                      toDelegate: PhysioEnterPoint(),
                    ));
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
                          child: FutureBuilder(
                              future: getInstruction(),
                              builder: (context, snapshot) =>
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? SpinKitFadingFour(
                                          color: Appcolors.primary,
                                        )
                                      : Text(
                                          snapshot.data ?? "",
                                          style: TextStyle(
                                            fontFamily: "Laxout",
                                            fontSize: 12,
                                          ),
                                        )),
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
                      return SpinKitFadingFour(
                        color: Appcolors.primary,
                      );
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
            height: 30,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DesignerItem1(
                      Image.asset("assets/images/Nacken_illustration.jpg"),
                      "Nacken-\nschmerzen",
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UebungHomeEnterPoint(
                              controlltime: 150,
                              index: 0,
                              workouts: [
                                UebungList(
                                  added: false,
                                  looping: true,
                                  imagePath: "assets/images/Nacken.png",
                                  execution:
                                      "Stehe Hüftbreit und gehe leicht in die Knie. Die Arme hängen dabei nach unten, während deine Schultern eine Kreisbewegung machen. Wichtig ist das die Schultern erst so weit wie möglich nach oben gehen und dann langsam abgesenkt werden.",
                                  name: "Schulterblattkreisen",
                                  dauer: 30,
                                  videoPath:
                                      "assets/videos/schuterblattkreisen.mp4",
                                  instruction: '',
                                  id: 1,
                                  timer: true,
                                  required: '',
                                ),
                                UebungList(
                                  added: false,
                                  looping: true,
                                  imagePath: "assets/images/Nacken.png",
                                  execution:
                                      "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus.",
                                  name: "Halbkreise Links",
                                  dauer: 30,
                                  videoPath:
                                      "assets/videos/Halbkreisnackenlinks.mp4",
                                  instruction: '',
                                  id: 2,
                                  timer: true,
                                  required: 'Stuhl',
                                ),
                                UebungList(
                                  added: false,
                                  looping: true,
                                  imagePath: "assets/images/Nacken.png",
                                  execution:
                                      "Wichtig ist dass du aufrecht an der Stuhlkante sitzt und deine Schultern hängen lässt. Führe die Übung bitte langsam aus.",
                                  name: "Halbkreise Rechts",
                                  dauer: 30,
                                  videoPath:
                                      "assets/videos/HalbkreisNackenrechts.mp4",
                                  instruction: '',
                                  id: 3,
                                  timer: true,
                                  required: 'Stuhl',
                                ),
                                UebungList(
                                  added: false,
                                  looping: false,
                                  imagePath: "assets/images/Nacken.png",
                                  execution:
                                      "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                                  name: "Dehnung Links Hinten",
                                  dauer: 30,
                                  videoPath:
                                      "assets/videos/nackenLinksHinten.mp4",
                                  instruction: '',
                                  id: 4,
                                  timer: true,
                                  required: '',
                                ),
                                UebungList(
                                  added: false,
                                  looping: false,
                                  imagePath: "assets/images/Nacken.png",
                                  execution:
                                      "Gehe langsam in die Dehnung, halte sie und bewege deine Schultern nicht. Außerdem ist es gut, wenn du aufrecht sitzt. Bist du fertig mit der Übung, verlasse die Dehnung nicht zu schnell.",
                                  name: "Dehnung Rechts Hinten",
                                  dauer: 30,
                                  videoPath:
                                      "assets/videos/nackenRechtsHinten.mp4",
                                  instruction: '',
                                  id: 5,
                                  timer: true,
                                  required: '',
                                ),
                              ],
                              workoutId: 3,
                            ),
                          ))),
                  DesignerItem1(
                      Image.asset(
                        'assets/images/mittlerer_Ruecken_illustartion.jpg',
                      ),
                      'Mittlerer \n Rücken',
                      () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UebungHomeEnterPoint(
                                    controlltime: 150,
                                    index: 0,
                                    workouts: [
                                      UebungList(
                                        added: false,
                                        looping: true,
                                        imagePath:
                                            "assets/images/MittlererRuecken.png",
                                        execution:
                                            "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Bei der Drehnung darf sich dein Becken und dein Kopf nicht bewegen. Tipp nehme hierfür deine Hände, wie gezeigt vor die Brust.",
                                        name: "Rotation Oberkörper",
                                        dauer: 30,
                                        videoPath:
                                            "assets/videos/rotationMittlererR.mp4",
                                        instruction: '',
                                        id: 14,
                                        timer: true,
                                        required: 'Stuhl',
                                      ),
                                      UebungList(
                                        added: false,
                                        looping: false,
                                        imagePath:
                                            "assets/images/MittlererRuecken.png",
                                        execution:
                                            "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                                        name: "Seitliche Dehnung links",
                                        dauer: 30,
                                        videoPath:
                                            "assets/videos/seitlicheDehnunglins.mp4",
                                        instruction: '',
                                        id: 15,
                                        timer: true,
                                        required: 'Stuhl',
                                      ),
                                      UebungList(
                                        added: false,
                                        looping: false,
                                        imagePath:
                                            "assets/images/MittlererRuecken.png",
                                        execution:
                                            "Setze dich so an die Stuhlkante, dass deine Knie auseinander sind und du aufrecht sitzt. Neige dich nun mit ausgestrecktem Arm zur Seite und versuche tief zu atmen. Schau dabei auf den Boden, der gerade vor dir ist.",
                                        name: "Seitliche Dehnung rechts",
                                        dauer: 30,
                                        videoPath:
                                            "assets/videos/seitlicheDehnungm.rechts.mp4",
                                        instruction: '',
                                        id: 16,
                                        timer: true,
                                        required: 'Stuhl',
                                      ),
                                      UebungList(
                                        added: false,
                                        looping: false,
                                        imagePath:
                                            "assets/images/MittlererRuecken.png",
                                        execution:
                                            "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                                        name: "Brustwirbelsäule links",
                                        dauer: 30,
                                        videoPath:
                                            "assets/videos/brustwirbelsauleLinks.mp4",
                                        instruction: '',
                                        id: 17,
                                        timer: true,
                                        required: 'Matte',
                                      ),
                                      UebungList(
                                        added: false,
                                        looping: false,
                                        imagePath:
                                            "assets/images/MittlererRuecken.png",
                                        execution:
                                            "Lege dir für diese Übung am besten ein Kissen wie gezeigt unter. Dannach geht der ausgestreckte Arm zur anderen Seite, während du ihm nachschaust und dein Kopf sich mit ihm mitbewegt.",
                                        name: "Brustwirbelsäule rechts",
                                        dauer: 30,
                                        videoPath:
                                            "assets/videos/brustwirbelsauleRechts.mp4",
                                        instruction: '',
                                        id: 18,
                                        timer: true,
                                        required: 'Kissen',
                                      ),
                                    ],
                                    workoutId: 5,
                                  )),
                          (route) => false)),
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DesignerItem1(
                    Image.asset(
                        'assets/images/Unterer_ruecken_illustration.png',
                        height: 100.0,
                        width: 100.0),
                    'Unterer Rücken',
                    () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UebungHomeEnterPoint(
                                  controlltime: 120,
                                  index: 0,
                                  workouts: [
                                    UebungList(
                                      added: false,
                                      looping: true,
                                      imagePath:
                                          "assets/images/UntererRuecken.png",
                                      execution:
                                          "Setze dich aufrecht an die Stuhlkante und beginne mit dem Becken zu kreisen. Der Oberkörper muss möglichst ruhig bleiben.",
                                      name: "Bewegung Unterer Rücken",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/beckenschuakel.mp4",
                                      instruction: '',
                                      id: 10,
                                      timer: true,
                                      required: 'Stuhl',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: true,
                                      imagePath:
                                          "assets/images/UntererRuecken.png",
                                      execution:
                                          "Du schaust gerade nach oben zur Decke. Lege deine Beine langsam und abwechselnd links und rechts zur Seite ab. Dabei bewegt sich dein Oberkörper nicht.",
                                      name: "Plumpsen",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/Plumpsenrechtslinks.mp4",
                                      instruction: '',
                                      id: 11,
                                      timer: true,
                                      required: 'Matte',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath:
                                          "assets/images/UntererRuecken.png",
                                      execution:
                                          "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht.",
                                      name: "Dehnung Unterer Rücken r",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/untererRueckenrechts.mp4",
                                      instruction: '',
                                      id: 12,
                                      timer: true,
                                      required: 'Matte',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath:
                                          "assets/images/UntererRuecken.png",
                                      execution:
                                          "Du schaust gerade nach oben zur Decke. Dannach legst du deine Beine langsam zur Seite ab und hältst die Dehnung. Dabei bewegt sich dein Oberkörper nicht",
                                      name: "Dehnung Unterer Rücken l",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/untererRueckenlinks.mp4",
                                      instruction: '',
                                      id: 13,
                                      timer: true,
                                      required: 'Matte',
                                    ),
                                  ],
                                  workoutId: 6,
                                )),
                        (route) => false)),
                const SizedBox(
                  height: 40,
                ),
                DesignerItem1(
                    Image.asset('assets/images/Schulter_illustartion.jpg',
                        height: 100.0, width: 100.0),
                    'Schultergürtel',
                    () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UebungHomeEnterPoint(
                                  controlltime: 120,
                                  index: 0,
                                  workouts: [
                                    UebungList(
                                      added: false,
                                      looping: true,
                                      imagePath: "assets/images/Nacken.png",
                                      execution:
                                          "Stehe Hüftbreit und gehe leicht in die Knie. Die Arme hängen dabei nach unten, während deine Schultern eine Kreisbewegung machen. Wichtig ist das die Schultern erst so weit wie möglich nach oben gehen und dann langsam abgesenkt werden.",
                                      name: "Schulterblattkreisen",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/schuterblattkreisen.mp4",
                                      instruction: '',
                                      id: 1,
                                      timer: true,
                                      required: '',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath: "assets/images/Schultern.png",
                                      execution:
                                          "Lege deine Hände im geschätzen 45 Grad Winkel wie gezeigt an die Wand. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                                      name: "Schulterdehnung 45 Grad",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/schulterdehnung.mp4",
                                      instruction: '',
                                      id: 6,
                                      timer: true,
                                      required: 'Wandecke',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath: "assets/images/Schultern.png",
                                      execution:
                                          "Lege deine Hände so hoch wie möglich an die Wand, wie als ob dich jemand nach oben zieht. Dannach machst du einen Ausfallschritt und verlagerst dein Gewicht langsam nach vorne.",
                                      name: "Schulterdehnung 90 Grad ",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/schulterdehnungGerade.mp4",
                                      instruction: '',
                                      id: 7,
                                      timer: true,
                                      required: 'Wandecke',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath: "assets/images/Schultern.png",
                                      execution:
                                          "Lasse deinen Nacken locker, wärend deine Hände sich auf Arschhöhre verschränken. Deine Schultern gehen nun hinten zusammen, während die Hände nach unten gezogen werden.",
                                      name: "Aufrichten",
                                      dauer: 30,
                                      videoPath:
                                          "assets/videos/aufrichtenoberkoerper.mp4",
                                      instruction: '',
                                      id: 8,
                                      timer: true,
                                      required: '',
                                    ),
                                    UebungList(
                                      added: false,
                                      looping: false,
                                      imagePath: "assets/images/Schultern.png",
                                      execution:
                                          "Deine Hände sind auf Brusthöhe, während du dich nach vorne neigst, als ob jemand an deinen Unterarmen zieht. Stell dir vor du willst etwas vor dir umarmen.",
                                      name: "Bagger",
                                      dauer: 30,
                                      videoPath: "assets/videos/bagger.mp4",
                                      instruction: '',
                                      id: 9,
                                      timer: true,
                                      required: '',
                                    ),
                                  ],
                                  workoutId: 4,
                                )),
                        (route) => false)),
              ],
            ),
          ),
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}
