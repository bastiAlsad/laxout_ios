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
  void navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyBottomNavigationBar(
                  startindex: 0,
                )),
        (route) => false);
  }

  double valueUmfrage = 1.0;
  bool ausgefuellt = false;
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
                                        print(value);
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
                        Expanded(
                            child: Image.asset("assets/images/umfrage.png")),
                        InkWell(
                          onTap: () {
                            if (ausgefuellt == true) {
                              setState(() {
                                showResults = true;
                                showSucces();
                              });
                            }
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
