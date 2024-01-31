import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:new_projekt/heatmap/hive.dart';
import 'package:new_projekt/models/ownWoDialog.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:new_projekt/variablePages/ownWoenterPoint.dart';
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
          "Eigene Workouts",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Laxout",
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                ),
                color: Color.fromRGBO(176, 224, 230, 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: _hive.workouts.isEmpty
                    ? Align(
                      alignment: Alignment.topCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.width / 1.4,
                          width: MediaQuery.of(context).size.width / 1.4,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.white, image: const DecorationImage(image: AssetImage("assets/images/loadingScreen.png"))),       
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Erstelle eigene Workouts",textAlign: TextAlign.center ,style: TextStyle(fontFamily: "Laxout",fontSize: 20),),
                            ],
                          ),                     
                        ),
                      )
                    : GridView.builder(
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
                      ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150.0,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                margin: const EdgeInsets.fromLTRB(40, 70, 40, 20),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.white;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_hive.workouts.length < 4) {
                      newWorkout();
                    } else {
                      userNotification();
                    }
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 35,
                      ),
                      Expanded(
                        child: Text(
                          'Neues Workout',
                          style: TextStyle(fontSize: 25, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const SideNavBar(),
    );
  }
}
