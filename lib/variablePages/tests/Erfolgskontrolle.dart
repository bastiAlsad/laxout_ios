import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

class SeeSuccesPage extends StatefulWidget {
  const SeeSuccesPage({super.key});

  @override
  State<SeeSuccesPage> createState() => _SeeSuccesPageState();
}

class _SeeSuccesPageState extends State<SeeSuccesPage> {
  double valueUmfrage = 1.0;
  bool ausgefuellt = false;
  String funnyValue = "Bitte bewegen Sie den Slider";
  final HiveDatabase _hive = HiveDatabase();
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  late double initialValue;
   void _sendPainLevel() async {
    await _laxoutBackend.postPainLevel(valueUmfrage.round());
  }

  void showSliderAnimation() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        valueUmfrage = initialValue + 3;
      });
      Future.delayed(Duration(milliseconds: 900), () {
        setState(() {
          valueUmfrage = initialValue;
        });
      });
    });
  }

  int tutorialCount = 0;
  String text1 = "Herzlichen Glückwunsch!"; //Title text
  String text2 =
      "Sie haben Ihr 1. Kursprogramm abgeschlossen! Weiter so!"; //Body text
  String text3 = "Fortfahren"; //Button text
  void showWelcomeDialog() {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(
              text1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Laxout", fontSize: 22, color: Colors.black),
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Laxout",
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      tutorialCount++;
                      if (tutorialCount == 1) {
                        setState(() {
                          text1 = "Die Erfolgskontrolle";
                          text2 =
                              "Lassen Sie uns nun schauen, wie sich das Workout auf Ihr Wohlbefinden ausgeübt hat. Normalerweise sollten Sie sich deutlich besser fühlen als vorher.";
                          text3 = "Weiter";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if (tutorialCount == 2) {
                        setState(() {
                          text1 = "Wie geht das ?";
                          text2 =
                              "Die App errechnet aus dem Wert, den Sie vorher angegeben haben und den Wert den Sie gleich beim Slider eingeben werden eine prozentuale Verbesserung, bzw. Verschlechterung. Machen Sie nun wie vorher eine Angabe per Slider zu Ihrem Wohlbefinden, um Ihr Ergebnis zu erfahren.";
                          text3 = "Los";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if (tutorialCount == 3) {
                        Navigator.of(context).pop();
                        showSliderAnimation();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Appcolors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          text3,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        }));
  }

  bool showTutorial = false;
  void navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyBottomNavigationBar(
                  startindex: showTutorial?1:0,
                )),
        (route) => false);
  }

  bool showResults = false;
  bool gotWorse = false;
  String word = "";
  double percent = 0;
  final HiveDatabase _hiveDatabase = HiveDatabase();
  final LaxoutBackend _backend = LaxoutBackend();
  void showSucces() {
    int storedIndex = _hiveDatabase.getSuccesIndex();

    print("hive: $storedIndex");
    print("local value: ${valueUmfrage}");

    if (storedIndex > valueUmfrage) {
      setState(() {
        gotWorse = true;
        percent = (1 - valueUmfrage / storedIndex) * 100;
        print("schlechter ${1 - valueUmfrage / storedIndex}");
        word = "schlechter";
      });
    } else if (storedIndex < valueUmfrage) {
      setState(() {
        gotWorse = false;
        percent = (1 - storedIndex / valueUmfrage) * 100;
        print("besser ${1 - storedIndex / valueUmfrage}");
        word = "besser";
      });
    } else {
      setState(() {
        gotWorse = false;
        percent = 0;
        word = "gleich geblieben";
      });
    }
  }

  @override
  void initState() {
    showSucces();
    showTutorial = !_hive.geterfolgskontrolleWasOpened();
    _hive.erfolgskontrolleWasOpened();
    showTutorial? WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog();
    }):(){};
    initialValue = valueUmfrage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Erfolgskontrolle:",
          style: TextStyle(
            fontFamily: "Laxout",
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: showResults
          ? Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ihnen geht es um ${percent.round()}% $word als vorher!",
                      style: TextStyle(
                          fontFamily: "Laxout",
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                    gotWorse
                        ? Text(
                            "Vielleicht reden Sie mit ihrem Physiotherapeuten darüber, was verbesert werden kann.",
                            style: TextStyle(
                                fontFamily: "Laxout",
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          )
                        : SizedBox(),
                    Expanded(child: Image.asset("assets/images/welldone.png")),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Ihre Belohnung:",
                            style: TextStyle(
                              fontFamily: "Laxout",
                            ))),
                    SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "+ 100",
                              style: const TextStyle(
                                  fontFamily: "Laxout", fontSize: 20),
                            ),
                            SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset("assets/images/laxCoin.png"),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        await _backend.postSuccessControll(!gotWorse);
                        navigate();
                      },
                      child: Container(
                        height: 60,
                        width: 210,
                        decoration: BoxDecoration(
                            color: ausgefuellt
                                ? Appcolors.primary
                                : const Color.fromRGBO(159, 217, 221, 1),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Center(
                          child: Text(
                            "Fertig",
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
              ),
            )
          : Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Wie fühlen Sie sich gerade von 1-10?",
                              style: TextStyle(
                                fontFamily: "Laxout",
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "Laxout"),
                                ),
                                Expanded(
                                  child: Slider(
                              value: valueUmfrage,
                              onChanged: ((value) {
                                setState(() {
                                  valueUmfrage = value;
                                  if (valueUmfrage <= 2) {
                                    funnyValue =
                                        "Ich komme kaum noch aus dem Bett";
                                  } else if (valueUmfrage <= 3) {
                                    funnyValue =
                                        "Mir tut alles weh";
                                  } else if (valueUmfrage <= 4) {
                                    funnyValue = "Das Aufstehen war auch schon mal leichter";
                                  } else if (valueUmfrage <= 5) {
                                    funnyValue = "Gut, dass ich Laxout habe";
                                  } else if (valueUmfrage <= 6) {
                                    funnyValue = "Nicht super aber es geht";
                                  } else if (valueUmfrage <= 7) {
                                    funnyValue =
                                        "Mir geht es ganz gut";
                                  } else if (valueUmfrage <= 8) {
                                    funnyValue =
                                        "Mir geht es gut";
                                  }
                                  else if (valueUmfrage <= 9) {
                                    funnyValue =
                                        "Mir geht es sehr gut";
                                  } else if (valueUmfrage < 10) {
                                    funnyValue =
                                        "Mir geht es super";
                                  }else {
                                    funnyValue = "Mir geht es prächtig";
                                  }
                                });
                              }),
                              activeColor: Appcolors.primary,
                              inactiveColor: Appcolors.primary,
                              divisions: 10,
                              label: valueUmfrage.round().toString(),
                              min: 1,
                              max: 10,
                              secondaryTrackValue: valueUmfrage,
                              onChangeStart: (value) {
                                setState(() {
                                  ausgefuellt = true;
                                });
                              },
                            ),
                                ),
                                const Text(
                                  "10",
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "Laxout"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(funnyValue, style: TextStyle(fontFamily: "Laxout", fontSize: 13, color: Colors.black),),
                        Expanded(
                            child: Image.asset("assets/images/umfrage.png")),
                        InkWell(
                          onTap: () {
                            if (ausgefuellt == true) {
                              setState(() {
                                _sendPainLevel();
                                showResults = true;
                                showSucces();
                              });
                            }else{
                              showSliderAnimation();
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 210,
                            decoration: BoxDecoration(
                                color: ausgefuellt
                                    ? Appcolors.primary
                                    : Appcolors.primary,
                                borderRadius: BorderRadius.circular(14)),
                            child: const Center(
                              child: Text(
                                "Ergebniss Ansehen",
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
                  ),
                )
              ],
            ),
    );
  }
}
