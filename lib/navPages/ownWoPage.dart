import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/ownWoDialog.dart';
import 'package:new_projekt/models/ownWorkoutList.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/DesignerItem1.dart';
import 'package:new_projekt/variablePages/uebungHomeenterpoint.dart';
import '../navigation/Side_Nav_Bar.dart';


class ownWorkoutPage extends StatefulWidget {
  const ownWorkoutPage({Key? key}) : super(key: key);

  @override
  State<ownWorkoutPage> createState() => _ownWorkoutPageState();
}

class _ownWorkoutPageState extends State<ownWorkoutPage> {
  int dayCount = 0;
  final HiveDatabase _hive = HiveDatabase();
  final HiveHeatmap _heatmap = HiveHeatmap();
  final _myBox = Hive.box("Workout_Map");
  bool added = false;
  bool provider = false;
  int ownWorkoutIndex = 0;
  int test = 0;
  List<String> imgageLIst = [
    "assets/images/ownWO.png",
    "assets/images/laxout3.png",
    "assets/images/fitness.png",
    "assets/images/workout1.png"
  ];
  String nameWorkout = "";
  List<DateTime> days = [];
  List<DateTime> today = [];

  _ownWorkoutPageState(); ///////////////////////

  void addWorkout(String todo) {
    setState(() {
      _hive.workouts[todo] = false;
    });
    Navigator.of(context).pop();
  }

  void deleteWorkout(String key) {
    setState(() {
      _hive.workouts.remove(key);
    });
  }

  void toggleDone(String key) {
    setState(() {
      _hive.workouts.update(key, (bool? done) => done != null ? !done : false);
    });
  }

  void userNotification() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Du kannst ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    " maximal 4 Workouts",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    "erstellen",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              )),
            ),
          );
        });
  }

  void newWorkout() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ownWoDialog(addWorkout: addWorkout),
        ));
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        toolbarHeight: 70,
        centerTitle: true,
        title: const Text(
          "Extra Workouts",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Laxout",
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(children: [
        
       
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
          
          
      ],),
      drawer: const SideNavBar(),
     
                  
    );
  }
}




/*
GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 Container in einer Zeile
                          // Verhältnis der Container-Breite zur Container-Höhe
                        ),
                        itemCount: _hive.workouts
                            .length, // Anzahl der Container entspricht der Anzahl der Workouts
                        itemBuilder: (context, index) {
                          String key = _hive.workouts.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(top: 9),
                              width: 250,
                              height: 440,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OwnWorkoutEnterPoint(
                                          index: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: 135,
                                        width: 135,
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          child: Image.asset(
                                              imgageLIst[index]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          key,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            height: 1,
                                            fontFamily: "Laxout",
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                      ),*/