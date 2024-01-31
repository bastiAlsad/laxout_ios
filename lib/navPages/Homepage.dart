// ignore_for_file: must_be_immutable
//_hiveCredit.getCredits()
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/models/ownWorkoutList.dart';
import 'package:new_projekt/navPages/errorPage.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/DesignerItem1.dart';
import 'package:new_projekt/variablePages/Uebung.dart';
import 'package:new_projekt/variablePages/physio/physioWorkoutEnterpoint.dart';
import 'package:new_projekt/variablePages/tests/umfrage.dart';
import 'package:new_projekt/variablePages/uebungHomeenterpoint.dart';
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
    final toConvert = await _laxoutBackend.returnLaxoutExercises();

    final toReturn = await _hive.convertStrenghtWorkoutsToUebungList(toConvert);
    return toReturn;
  }

  String instruction = "";
  bool logoValid = true;

 


  Future<void> manageInstruction()async{ 
    String? testinsruction = "";
    testinsruction = await _laxoutBackend.returnInstruction();
    if(testinsruction != null){
      _hive.putInstructionToHive(testinsruction);
    }else{
      _hive.putInstructionToHive("Keine Anweisung vorhanden");
    }
  }
  

  @override
  void initState() {
    isInternetConnected();
    isConnected ? putConvertedListInHive() : () {};
    isConnected ? manageInstruction():(){};
    isConnected ? putConvertedTestListInHive() : () {};
    instruction = _hive.getInstruction();
    if (isConnected == true) {
      //&& _hiveCredit.getPraxisName() == ""
    
    }

    list = _hive.getPhysioWorkoutList();
    // list.isNotEmpty ? instruction = list[0].instruction : () {};
    _initializeApp();
    days = _heatmap.getDaysList();
    today = _heatmap.getToday();
    if (_myBox.isEmpty) {
      _hive.createInitialData();
    } else {
      _hive.loadData();
    }
    _hive.loadOwnWorkout();
    _hive.loadOwnWorkout2();
    _hive.loadOwnWorkout3();
    _hive.loadOwnWorkout4();
    _hive.selectedList();
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
                              builder: (context) =>
                                  const MyBottomNavigationBar()),
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
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 60,
        leading: Row(
          children: [
            const SizedBox(
              width: 8,
            ),
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Image.asset('assets/images/drawer.png')),
          ],
        ),
        centerTitle: true,
        actions: [
          SizedBox(
              height: 60,
              width: 60,
              child: Image.asset("assets/images/Logoohneschrift.png")),

          /*
              logoValid
                  ? Image.network(praxisDetails!.logo)
                  : Image.asset("assets/images/Logoohneschrift.png")*/
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
                      list.isNotEmpty
                          ? showNeededStuff(
                              requiredTestStuff(), const UmfragePage())
                          : Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ErrorPage()),
                              (route) => false);
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
                showNeededStuff(requiredStuff(), const PhysioEnterPoint());

                /* Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const PhysioEnterPoint()),
                    (route) => false);*/
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
                          child: Text(
                            instruction,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontFamily: "Laxout", fontSize: 13),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder<String?>(
                future: _getLaxCoinsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
                          style: TextStyle(fontFamily: "Laxout", fontSize: 20),
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
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}

class TabBarItem extends StatefulWidget {
  String title;
  String dauer;
  String imagePath;
  VoidCallback onPressed;
  TabBarItem({
    Key? key,
    required this.title,
    required this.dauer,
    required this.imagePath,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<TabBarItem> createState() => _TabBarItemState();
}

class _TabBarItemState extends State<TabBarItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        height: 200,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(176, 224, 230, 1.0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 20,
                offset: Offset(5, 0),
                color: Colors.black12,
              )
            ]),
        child: Stack(
          children: [
            Positioned(
                top: 20,
                left: 10,
                child: Image.asset(
                  widget.imagePath,
                  scale: 3,
                )),
            Positioned(
                top: 20,
                right: 55,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.watch_outlined,
                            color: Colors.white,
                            size: 25,
                          ),
                          Text(
                            widget.dauer,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: widget.onPressed,
                          child: Container(
                              height: 35,
                              width: 120,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Center(
                                child: Text(
                                  'Start',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              )))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class DifferentWorkouts extends StatelessWidget {
  final Widget picture;
  final String title;
  final Function navigate;
  const DifferentWorkouts(this.picture, this.title, this.navigate, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15.0,
            offset: Offset(0, 8),
          )
        ],
      ),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return const Color.fromRGBO(176, 224, 230, 1.0);
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ))),
        onPressed: () {
          navigate();
        },
        child: Column(
          children: <Widget>[
            picture,
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
