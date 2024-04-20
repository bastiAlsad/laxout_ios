import 'package:flutter/material.dart';
import 'package:new_projekt/models/constans.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';

class UmfragePage extends StatefulWidget {
  final Widget toDelegate;
  const UmfragePage({Key? key, required this.toDelegate}) : super(key: key);

  @override
  State<UmfragePage> createState() => _UmfragePageState();
}

class _UmfragePageState extends State<UmfragePage> {
  double valueUmfrage = 1.0;
  bool ausgefuellt = false;
  String funnyValue = "Bitte bewegen Sie den Slider";
  final LaxoutBackend _laxoutBackend = LaxoutBackend();
  final HiveDatabase _hive = HiveDatabase();
  late double initialValue;

  void showSliderAnimation(){
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
String text1 = "Super, Sie haben es hierher geschafft!";//Title text
String text2 = "Nun können wir auch schon mit einem kurzen Check Ihres Wohlbefindens fortfahren.";//Body text
String text3 = "Fortfahren"; //Button text
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
                          text1 = "Warum brauche ich das ?";
                          text2 = "Sie werden in der App vor und nach dem Workout nach Ihrem Wohlbefinden gefragt, um nachvollziehen zu können ob, Sie sich nach dem Workout besser als vorher fühlen. Dies bekommen Sie am Ende des Workouts angezeigt.";
                          text3 = "Weiter";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 2){
                        setState(() {
                          text1 = "Lassen Sie es uns ausprobieren!";
                          text2 = "Drücken Sie nun auf Los und bewegen Sie anschließen den Slider so, dass ein Ergebnis angezeigt wird, welches Ihrem aktuellen Wohlbefinden entspricht. Auf geht's!";
                          text3 = "Los";
                        });
                        Navigator.of(context).pop();
                        showWelcomeDialog();
                      }
                      if(tutorialCount == 3){
                        Navigator.of(context).pop();
                        showSliderAnimation();
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
    showTutorial = !_hive.getUmfrageWasOpened();
    _hive.umfrageWasOpened();
    showTutorial? WidgetsBinding.instance.addPostFrameCallback((_) {
      showWelcomeDialog();
    }):(){};
    super.initState();
    initialValue = valueUmfrage;
    // Verschiebe den Slider kurz nach rechts und dann zurück
    
  }

  void _sendPainLevel() async {
    await _laxoutBackend.postPainLevel(valueUmfrage.round());
  }

  void _putUmfrageValue() {
    _hive.putSuccesIndex(valueUmfrage.round());
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Umfrage:",
          style: TextStyle(
            fontFamily: "Laxout",
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Wie fühlen Sie sich gerade von 1-8?",
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
                            style:
                                TextStyle(fontSize: 15, fontFamily: "Laxout"),
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
                                  } else {
                                    funnyValue = "Mir geht es super";
                                  }
                                });
                              }),
                              activeColor: Appcolors.primary,
                              inactiveColor: Appcolors.primary,
                              divisions: 8,
                              label: valueUmfrage.round().toString(),
                              min: 1,
                              max: 8,
                              secondaryTrackValue: valueUmfrage,
                              onChangeStart: (value) {
                                setState(() {
                                  ausgefuellt = true;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "8",
                            style:
                                TextStyle(fontSize: 15, fontFamily: "Laxout"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(funnyValue, style: TextStyle(fontFamily: "Laxout", fontSize: 13, color: Colors.black),),
                  Expanded(child: Image.asset("assets/images/umfrage.png")),
                  InkWell(
                    onTap: () {
                      if (ausgefuellt == true) {
                        _putUmfrageValue();
                        _sendPainLevel();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    widget.toDelegate),
                            (route) => false);
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
                          "Bestätigen",
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
