import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_projekt/models/constans.dart';
// import 'package:new_projekt/models/textfield.dart';
import 'package:new_projekt/navigation/Bottom_Navigation_Bar.dart';
import 'package:new_projekt/services/basti_backend.dart';
import 'package:new_projekt/services/hive_communication.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterAcess extends StatefulWidget {
  const EnterAcess({super.key});

  @override
  State<EnterAcess> createState() => _EnterAcessState();
}

class _EnterAcessState extends State<EnterAcess> {
  LaxoutBackend _bastiBackend = LaxoutBackend();
  String textFromFile = "";
  getText(String text) async {
    String newText;
    newText = await rootBundle.loadString(text);
    setState(() {
      textFromFile = newText;
    });
  }


  bool neverOpened = false;
  final HiveDatabase _hive = HiveDatabase();
  bool registert = false;
  bool checkboxValue = false;
  bool authenticationError = false;
  final Uri _datapolicyUrl = Uri.parse('https://laxoutapp.com/privacy-policy/');
  final Uri _agbyUrl = Uri.parse('https://laxoutapp.com/allgemeine-geschaeftsbedingungen-agb/');
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  bool _registriert() {
    if (_hive.neverOpened() != true) {
      return true;
    } else {
      return false;
    }
  }

  void navigate() {
    bool lizensiert = _registriert();
    if (lizensiert == true && checkboxValue == true) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const MyBottomNavigationBar(
                    startindex: 0,
                  )),
          (route) => false);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    showErrorMessage(String alert) {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: Text(
                alert,
                style: const TextStyle(fontFamily: "Laxout", fontSize: 14),
              ),
              actions: [
                Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
                ),
              ],
            );
          }));
    }
     Future<void> authenticateAfterError() async {
      print("autehntication");
      bool check = await _bastiBackend.authenticateUser("3a3d824d-917e-47b7-a4e1-d4fa84429418");
      if (check == true) {
        navigate();
      } else {
        print("error");
      }
    }

    Future<void> authenticate(String code) async {
      print("autehntication");
      bool check = await _bastiBackend.authenticateUser(code);
      if (check == true) {
        navigate();
      } else {
        authenticateAfterError();//   3a3d824d-917e-47b7-a4e1-d4fa84429418
      }
    }

    Future<String> pasteFromClipboard() async {
      print("aufgerufen");
      String text = "";
      ClipboardData? clipboardData =
          await Clipboard.getData(Clipboard.kTextPlain);
      // Wenn Daten vorhanden sind, setze sie in das Textfeld ein
      if (clipboardData != null && clipboardData.text != null) {
        setState(() {
          print("text zugewiesen:");
          text = clipboardData.text!;
          print(text);
        });

        return text;
      } else {
        return text;
      }
    }

    Future<void> inizialize()async{
      print("aufgerufen inizialize");
      String code = await pasteFromClipboard();
      await authenticate(code);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title:  Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Text(
            "Willkommen",
            style: TextStyle(
                color: Colors.black, fontSize: 45, fontFamily: "Laxout"),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 77, width: 77, child: Image.asset("assets/images/Logoohneschrift.png"),),
            
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 17),
            //   child: Container(
            //     height: 50,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(color: Appcolors.primary, width: 4),
            //         borderRadius: BorderRadius.circular(24)),
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Expanded(
            //               child: MyTextField(
            //                   controller: _controller,
            //                   text: "Bitte Praxiscode eingeben",
            //                   obscureText: false,
            //                   fontSize: 14)),
            //           IconButton(
            //               onPressed: () {
            //                 pasteFromClipboard();
            //               },
            //               icon:
            //                   Image.asset("assets/images/Logoohneschrift.png")),
            //           const SizedBox(
            //             width: 10,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Expanded(child: Image.asset("assets/images/enterAccesilu.png")),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        activeColor: Appcolors.primary,
                        value: checkboxValue,
                        onChanged: ((value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Ich akzeptiere die",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: "Laxout",
                                    fontSize: 12,
                                    height: 1),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _launchInBrowser(_datapolicyUrl);
                                  },
                                  child: const Text("Datenschutzerklärung",
                                      style: TextStyle(
                                          fontFamily: "Laxout",
                                          fontSize: 12,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          height: 1)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Ich akzeptiere die",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontFamily: "Laxout",
                                    fontSize: 12,
                                    height: 1),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _launchInBrowser(_agbyUrl);
                                  },
                                  child: const Text("AGBs",
                                      style: TextStyle(
                                          fontFamily: "Laxout",
                                          fontSize: 12,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          height: 1)))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                //Production:3a3d824d-917e-47b7-a4e1-d4fa84429418
                //Local:901f0603-f06f-4294-b2c6-da95dc9f25d4
                Padding(
                  padding:  const EdgeInsets.only(bottom: 40),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (checkboxValue == true) {
                            inizialize();
                          } else {
                            showErrorMessage(
                                "Bitte Stimmen Sie den AGBs und der Datenschutzerklärung zu.");
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 210,
                          decoration: BoxDecoration(
                              color: Appcolors.primary,
                              borderRadius: BorderRadius.circular(14)),
                          child: const Center(
                            child: Text(
                              "Loslegen",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Laxout",
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      // TextButton(
                      //     onPressed: () {
                      //       if (checkboxValue == true) {
                      //         authenticate("3a3d824d-917e-47b7-a4e1-d4fa84429418");
                      //       } else {
                      //         showErrorMessage(
                      //             "Bitte Stimmen Sie den AGBs und der Datenschutzerklärung zu.");
                      //       }
                      //     },
                      //     child: Text(
                      //       "App ohne Code nutzen",
                      //       style: TextStyle(
                      //           fontFamily: "Laxout",
                      //           color: Colors.grey.shade400,
                      //           fontSize: 13),
                      //     ))
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// Funktion schreiben, die angegebenen praxiscode speichert, wenn er richtig ist a